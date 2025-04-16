import 'dart:io';
import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../../home/data/data_sources/session_cache.dart';
import '../../../home/presentation/widgets/session_manager.dart';
import '../../../idealshot/domain/entities/ideal_shot.dart';
import '../../../sessions/data/dtos/AddDeliveryDTO.dart';
import '../../../sessions/domain/entities/delivery.dart';

class UploadVideoPage extends StatefulWidget {
  final void Function(int index)? navigateToTab;
  final VoidCallback? openSessionsManager;

  const UploadVideoPage({Key? key, this.navigateToTab, this.openSessionsManager}) : super(key: key);

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
        title: const Text(
          'Upload Video',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Upload or Record a Cricket Batting Video",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Nunito',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          _videoButtons(),
          const SizedBox(height: 20),
          Expanded(child: _videoPreview()),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: Text(
                    _isUploading ? 'Processing...' : 'Upload Video',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: pickVideo,
          icon: const Icon(Icons.video_library, color: AppColors.primary),
          label: const Text(
            'Select from Gallery',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: recordVideo,
          icon: const Icon(Icons.camera_alt, color: AppColors.primary),
          label: const Text(
            'Record a Video',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _videoPreview() {
    if (_videoPath != null &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return Column(
        children: [
          const Text(
            "Preview",
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
          IconButton(
            icon: const Icon(Icons.replay, color: AppColors.primary),
            onPressed: replayVideo,
          ),
        ],
      );
    } else {
      return const Center(
        child: Text(
          "No video selected.",
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
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

      final sessionId = await SessionManager.getActiveSessionId() ?? await SessionManager.createSession();

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
      final prefs = await SharedPreferences.getInstance();
      final playerId = prefs.getString('uid')!;

      final ballCharacteristics = deliveryData['ballCharacteristics'];
      final idealShotsList = deliveryData['idealShot']['predicted_ideal_shots'] as List;

      final deliveryDTO = AddDeliveryDTO(
        uid: playerId,
        sessionId: sessionId,
        videoUrl: deliveryData['videoUrl'],
        ballLength: ballCharacteristics['BallLength'],
        ballLine: ballCharacteristics['BallLine'],
        ballSpeed: ballCharacteristics['BallSpeed'],
        batsmanPosition: ballCharacteristics['BatsmanPosition'],
        predictedIdealShots: idealShotsList.map<Map<String, dynamic>>((s) => {
          'shot': s['shot'],
          'confidence_score': s['confidence_score'],
        }).toList(),
      );

      final addDeliveryResponse = await dioClient.post(
        ApiUrl.addDelivery,
        data: deliveryDTO.toJson(),
      );

      final _deliveryId = addDeliveryResponse.data['data']['deliveryId'];
      final _ballength = ballCharacteristics['BallLength'];
      final _ballLine = ballCharacteristics['BallLine'];
      final _ballSpeed = (ballCharacteristics['BallSpeed'] as num).toDouble();
      final _batsmanPosition = ballCharacteristics['BatsmanPosition'];
      final _videoUrl = deliveryData['videoUrl'];
      final _idealShots = idealShotsList.map<IdealShot>((s) => IdealShot(
        shot: s['shot'],
        confidenceScore: (s['confidence_score'] as num).toDouble(),
      )).toList();

      if (addDeliveryResponse.statusCode != 200 || _deliveryId == null) {
        throw Exception('Add delivery failed: ${addDeliveryResponse.data}');
      }

      final newDelivery = Delivery(
        deliveryId: _deliveryId,
        ballLength: _ballength,
        ballLine: _ballLine,
        ballSpeed: _ballSpeed,
        batsmanPosition: _batsmanPosition,
        videoUrl: _videoUrl,
        idealShots: _idealShots,
      );

      SessionCache().addDeliveryToSession(
        sessionId: sessionId,
        newDelivery: newDelivery,
      );

      if (widget.openSessionsManager != null) {
        widget.openSessionsManager!();
      }
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
