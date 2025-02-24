import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isLoading = true;

  final String videoUrl = "https://storage.googleapis.com/aicc-proj-1.firebasestorage.app/uploads/output_video.mp4?Expires=1896139906&GoogleAccessId=firebase-adminsdk-tx1c1%40aicc-proj-1.iam.gserviceaccount.com&Signature=ylD7nqxeXi213nX8K7SF1NSQxmANtWl1xn%2F7w%2FBzv3V5vK1kaATd1ETbRWIaMIH1t9AIb6trnpsYvtrAx6Er%2BUIEJQssBOpgRsogNM7BRmNKcbQM%2FjujYPjjfuErv2qZfvxrzzIEggcBefsEVrNlHOljF4V4Q5mqxFZx7Hkn6UEPX3YUDeMDdkHxMUvnVOwmUIkAgdz1UJ4vv09nKIcdbxwKxXww%2FMQRn0DtoZBh4cfXDADlFim7IDj5nBbGY06SYNMA5CxrcSaweYKNRm0O7Cy0SR9WcFFU5gyjaejdoOyJowNCZp55LgILQfX0xVkeGt%2FQET7dgsc5kHdNHHorPw%3D%3D";

  @override
  void initState() {
    super.initState();

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));


    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Streaming Video Player")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : AspectRatio(
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: Chewie(controller: _chewieController),
        ),
      ),
    );
  }
}
