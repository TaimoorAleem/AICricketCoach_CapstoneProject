// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'edit_video.dart';
//
// class UploadVideoPage extends StatefulWidget {
//   const UploadVideoPage({Key? key}) : super(key: key);
//
//   @override
//   _UploadVideoPageState createState() => _UploadVideoPageState();
// }
//
// class _UploadVideoPageState extends State<UploadVideoPage> {
//   VideoPlayerController? _videoController;
//   String? _videoPath;
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   Future<void> pickVideo() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
//
//     if (result != null) {
//       String path = result.files.single.path!;
//       _initializeVideo(path);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No video selected')),
//       );
//     }
//   }
//
//   Future<void> recordVideo() async {
//     final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
//
//     if (video != null) {
//       _initializeVideo(video.path);
//     }
//   }
//
//   void _initializeVideo(String path) {
//     setState(() {
//       _videoPath = path;
//       _videoController = VideoPlayerController.file(File(path))
//         ..initialize().then((_) {
//           setState(() {});
//         });
//     });
//   }
//
//   Future<void> uploadVideo() async {
//     if (_videoPath == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a video first')),
//       );
//       return;
//     }
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse('https://my-app-image-174827312206.us-central1.run.app/upload-video'));
//       request.files.add(await http.MultipartFile.fromPath('file', _videoPath!));
//
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Video uploaded successfully: ${response.body}')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Upload failed: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
//
//   void replayVideo() {
//     _videoController?.seekTo(Duration.zero);
//     _videoController?.play();
//   }
//
//   // void navigateToEditVideo() {
//   //   if (_videoPath != null) {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => EditVideoPage(videoPath: _videoPath!),
//   //       ),
//   //     );
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Video'),
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.camera_alt),
//             onPressed: recordVideo,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: pickVideo,
//                     child: const Text('Select Video from Gallery'),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_videoPath != null && _videoController != null && _videoController!.value.isInitialized)
//                     Stack(
//                       alignment: Alignment.bottomLeft,
//                       children: [
//                         Column(
//                           children: [
//                             AspectRatio(
//                               aspectRatio: _videoController!.value.aspectRatio,
//                               child: VideoPlayer(_videoController!),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.replay),
//                               onPressed: replayVideo,
//                             ),
//                           ],
//                         ),
//                         // Positioned(
//                         //   bottom: 10,
//                         //   left: 10,
//                         //   child: IconButton(
//                         //     icon: const Icon(Icons.edit),
//                         //     onPressed: navigateToEditVideo,
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20.0),
//             child: ElevatedButton(
//               onPressed: uploadVideo,
//               child: const Text('Upload Video'),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: _videoController != null && _videoController!.value.isInitialized
//           ? FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _videoController!.value.isPlaying
//                 ? _videoController!.pause()
//                 : _videoController!.play();
//           });
//         },
//         child: Icon(
//           _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       )
//           : null,
//     );
//   }
// }

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({Key? key}) : super(key: key);

  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  VideoPlayerController? _videoController;
  String? _videoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

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
    try {
      var request = http.MultipartRequest('POST', Uri.parse('https://my-app-image-174827312206.us-central1.run.app/upload-video'));
      request.files.add(await http.MultipartFile.fromPath('file', _videoPath!));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully: ${response.body}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void replayVideo() {
    _videoController?.seekTo(Duration.zero);
    _videoController?.play();
  }

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
                  if (_videoPath != null && _videoController != null && _videoController!.value.isInitialized)
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
            child: ElevatedButton(
              onPressed: uploadVideo,
              child: const Text('Upload Video'),
            ),
          ),
        ],
      ),
      floatingActionButton: _videoController != null && _videoController!.value.isInitialized
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _videoController!.value.isPlaying
                ? _videoController!.pause()
                : _videoController!.play();
          });
        },
        child: Icon(
          _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      )
          : null,
    );
  }
}


