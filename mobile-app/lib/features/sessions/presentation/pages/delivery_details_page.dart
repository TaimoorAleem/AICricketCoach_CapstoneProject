import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../../resources/session_cache.dart';
import '../../../idealshot/presentation/pages/ideal_shot_page.dart';
import '../../domain/entities/delivery.dart';

class DeliveryDetailsPage extends StatefulWidget {
  final String sessionId;
  final String deliveryId;

  const DeliveryDetailsPage({
    super.key,
    required this.sessionId,
    required this.deliveryId,
  });

  @override
  State<DeliveryDetailsPage> createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  Delivery? delivery;
  bool isCoach = false;

  final TextEditingController _feedbackController = TextEditingController();
  double _battingRating = 5.0;
  bool isSubmitting = false;

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _loadDelivery();
    _checkUserRole();
  }

  void _loadDelivery() {
    delivery = SessionCache().getDeliveryById(widget.sessionId, widget.deliveryId);
    if (delivery != null) {
      _feedbackController.text = delivery!.feedback ?? '';
      _battingRating = delivery!.battingRating ?? 5.0;
      _initializeVideoPlayer(delivery!.videoUrl);
    }
  }

  Future<void> _initializeVideoPlayer(String url) async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoPlayerController!.initialize();
    _videoPlayerController!.setVolume(0); // 🔇 Mute video

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
    );

    setState(() {});
  }

  Future<void> _checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    setState(() => isCoach = role == 'coach');
  }

  Future<void> _submitFeedback() async {
    setState(() => isSubmitting = true);

    SessionCache().updateDeliveryFeedback(
      sessionId: widget.sessionId,
      deliveryId: widget.deliveryId,
      rating: _battingRating,
      feedback: _feedbackController.text,
    );

    setState(() => isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted')),
    );
  }

  void _navigateToIdealShotPage() {
    if (delivery == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IdealShotPage(
          ballCharacteristics: {
            "Ball Speed": delivery!.ballSpeed,
            "Ball Length": delivery!.ballLength,
            "Ball Horizontal Line": delivery!.ballLine,
            "Batsman Position": delivery!.batsmanPosition,
          },
          shots: delivery!.idealShots,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (delivery == null) {
      return const Scaffold(
        body: Center(child: Text("Delivery not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized)
              AspectRatio(
                aspectRatio:
                _chewieController!.videoPlayerController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              )
            else
              const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 16),
            Text('Speed: ${delivery!.ballSpeed} km/h'),
            Text('Ball Line: ${delivery!.ballLine}'),
            Text('Ball Length: ${delivery!.ballLength}'),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _navigateToIdealShotPage,
              child: const Text("View Ideal Shot"),
            ),

            const SizedBox(height: 24),
            if (isCoach) _buildFeedbackSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Coach Feedback",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter your feedback...",
          ),
        ),
        const SizedBox(height: 10),
        const Text("Batting Rating (1–10):"),
        Slider(
          value: _battingRating,
          min: 1,
          max: 10,
          divisions: 9,
          label: _battingRating.toStringAsFixed(1),
          onChanged: (value) {
            setState(() => _battingRating = value);
          },
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: isSubmitting ? null : _submitFeedback,
            child: isSubmitting
                ? const CircularProgressIndicator()
                : const Text("Submit Feedback"),
          ),
        ),
      ],
    );
  }
}
