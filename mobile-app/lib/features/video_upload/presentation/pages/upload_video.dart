import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../../../resources/session_cache.dart';
import '../../../home/presentation/widgets/session_manager.dart';
import '../../../idealshot/domain/entities/ideal_shot.dart';
import '../../../sessions/domain/entities/delivery.dart';
import '../../../sessions/presentation/pages/delivery_details_page.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({Key? key}) : super(key: key);

  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  VideoPlayerController? _videoController;
  String? _videoPath;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: recordVideo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: pickVideo,
                    child: const Text('Select Video from Gallery'),
                  ),
                  const SizedBox(height: 20),
                  if (_videoPath != null &&
                      _videoController != null &&
                      _videoController!.value.isInitialized)
                    Column(
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                        IconButton(
                          icon: const Icon(Icons.replay),
                          onPressed: replayVideo,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                if (_isUploading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CircularProgressIndicator(),
                  ),
                ElevatedButton(
                  onPressed: _isUploading ? null : uploadVideo,
                  child: _isUploading
                      ? const Text('Uploading...')
                      : const Text('Upload Video'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _videoController != null &&
          _videoController!.value.isInitialized
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _videoController!.value.isPlaying
                ? _videoController!.pause()
                : _videoController!.play();
          });
        },
        child: Icon(
          _videoController!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      )
          : null,
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      String path = result.files.single.path!;
      _initializeVideo(path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No video selected')),
      );
    }
  }

  Future<void> recordVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);

    if (video != null) {
      _initializeVideo(video.path);
    }
  }

  void _initializeVideo(String path) {
    setState(() {
      _videoPath = path;
      _videoController = VideoPlayerController.file(File(path))
        ..initialize().then((_) {
          setState(() {});
        });
    });
  }

  Future<void> uploadVideo() async {
    if (_videoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video first')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final file = File(_videoPath!);
      final fileName = Path.basename(file.path);

      // Check or create session
      final sessionId =
          await SessionManager.getActiveSessionId() ?? await SessionManager.createSession();

      // Upload video
      final dioClient = await DioClient.init();
      final response = await dioClient.post(
        ApiUrl.uploadVideo,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path, filename: fileName),
        }),
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
        }),
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Upload failed');
      }

      final deliveryData = response.data;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Confirm Delivery'),
          content: const Text('Are you satisfied with the response?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Retake')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm')),
          ],
        ),
      ) ??
          false;

      if (!confirmed) return;

      // Create delivery
      final prefs = await SharedPreferences.getInstance();
      final playerId = prefs.getString('uid')!;

      final delivery = Delivery(
        deliveryId: deliveryData['deliveryId'],
        ballLength: deliveryData['ballCharacteristics']['BallLength'],
        ballLine: deliveryData['ballCharacteristics']['BallLine'],
        ballSpeed: deliveryData['ballCharacteristics']['BallSpeed'],
        batsmanPosition: deliveryData['ballCharacteristics']['BatsmanPosition'],
        videoUrl: deliveryData['videoUrl'],
        idealShots: (deliveryData['idealShot']['predicted_ideal_shots'] as List)
            .map((s) => IdealShot(
          shot: s['shot'],
          confidenceScore: s['confidence_score'].toDouble(),
        ))
            .toList(),
      );

      await dioClient.post(ApiUrl.addDelivery, data: {
        'playerId': playerId,
        'sessionId': sessionId,
        'deliveryId': delivery.deliveryId,
        'BallLength': delivery.ballLength,
        'BallLine': delivery.ballLine,
        'BallSpeed': delivery.ballSpeed,
        'BatsmanPosition': delivery.batsmanPosition,
        'videoUrl': delivery.videoUrl,
        'idealShot': {
          'predicted_ideal_shots': delivery.idealShots
              .map((s) => {'shot': s.shot, 'confidence_score': s.confidenceScore})
              .toList(),
        },
      });

      SessionCache().addDeliveryToSession(sessionId: sessionId, newDelivery: delivery);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeliveryDetailsPage(
            sessionId: sessionId,
            deliveryId: delivery.deliveryId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void replayVideo() {
    _videoController?.seekTo(Duration.zero);
    _videoController?.play();
  }
}
