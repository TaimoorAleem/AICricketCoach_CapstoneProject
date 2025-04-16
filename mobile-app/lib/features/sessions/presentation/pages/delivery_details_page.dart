import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../resources/app_colors.dart';
import '../../../home/data/data_sources/session_cache.dart';
import '../../domain/entities/delivery.dart';
import '../../../idealshot/domain/entities/ideal_shot.dart';
import '../../../idealshot/presentation/widgets/donut_chart.dart';

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

  final Map<String, String> shotGifMap = const {
    "Pull Shot": "https://media2.giphy.com/media/BzJVPvZ7WP048mVtXH/200w.gif",
    "Sweep": "https://media.tenor.com/me1ujZjGd8AAAAAM/ipl-gullybet.gif",
    "Leg Glance": "http://newsimg.bbc.co.uk/media/images/41958000/gif/_41958468_bf_leg_glance_416x300.gif",
    "Slog": "https://media1.tenor.com/m/q2Nd7FBhuXMAAAAd/one-kneed-slogsweep-shikar-dhawan.gif",
    "Drive Straight": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjLsnd_-emSL_Uibe4PsHG_RGpXtbLmac2urV5v6Wad_ElAfsW6CXClBUe3nexoWcXM-NkMO9AvDZ1ZZsWjz7_88WSGpiH7F5xmUKhGOZsTcFgkkG3GszjConMb1Sk570OxbFfWA375ummJ/s1600/ondrive.gif",
    "Block Shot Forward": "https://greatshotsir.wordpress.com/wp-content/uploads/2013/03/forward-defensive-sidet.gif",
    "Back-Foot Drive": "https://greatshotsir.wordpress.com/wp-content/uploads/2013/03/back-foot-drive.gif",
    "Upper Cut": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhOlBEEeYUAU718SdwWHPPJC5gn6jIrPElhPNpjVNDGjedCPEtduqO-I1pUvIFXXPgHjkDeRruReO_0fQTkGOA0iPDxTG1SaiupCMbNDsinKWHzDv1ssIbI9ry2V4Mhyphenhyphenb_avLfMh9WvQ_ci/s1600/vsakhtar.gif",
    "Hook Shot": "https://media1.tenor.com/m/Cx-lih1d67kAAAAd/sachin-tendulkar-tendulkar.gif",
    "Late Cut": "https://media.tenor.com/eNAyDeuyCLMAAAAM/sachin-tendulkar-sachin-late-cut.gif",
    "Straight Drive": "https://gifdb.com/images/thumbnail/quinton-de-kock-straight-drive-t5qeyymji5risetl.gif",
    "Lofted Drive Off": "https://media1.tenor.com/m/yI3zjVzQEWMAAAAd/bhibatsam-virat-kohli.gif",
    "Drive Off": "http://newsimg.bbc.co.uk/media/images/40715000/gif/_40715902_back_drive_anim.gif",
    "Lofted Off Drive": "https://media.tenor.com/B6jLPhW2krUAAAAM/bhibatsam-shubam-gill.gif",
    "Lofted Drive On": "https://cricketforbegginer.wordpress.com/wp-content/uploads/2014/04/40715902_back_drive_anim.gif",
    "Square Cut": "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExZHd4cWNvdzU1djdveHphNHp0aWlhbnFpbXB3dW5kZGQ3dmI0bTc3bSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/yDjgHGTbmuxLC3RxaW/giphy.gif",
    "Back-Foot Leg Glance": "https://newsimg.bbc.co.uk/media/images/41958000/gif/_41958468_bf_leg_glance_416x300.gif",
    "Drive Cover": "https://media.tenor.com/k3xsAvK7IIIAAAAM/signature-shot-virat-kohli.gif",
    "Cut": "https://i.makeagif.com/media/9-04-2015/6oubYp.gif",
    "Reverse Sweep": "https://i.makeagif.com/media/7-24-2015/WEcNFE.gif",
    "Lofted On Drive": "https://www.fanrank.org/votefor/1/sachin-tendulkar-on-drive-shot.gif",
    "Drive On": "https://www.stancebeam.com/assets/images/blog/on-drive-sikana-english.gif",
    "Lofted Straight Drive": "https://drive.google.com/file/d/1kM7SL-0n1P3mo0s5i_zyyFk4SLeeb2Fz/view"
  };

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
    _videoPlayerController!.setVolume(0);

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
        backgroundColor: AppColors.background,
        body: Center(child: Text("Delivery not found.")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: const Text(
          'Delivery Details',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized)
              AspectRatio(
                aspectRatio: _chewieController!.videoPlayerController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              )
            else
              const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 20),
            const Text(
              "Delivery Features Extracted",
              style: TextStyle(fontFamily: 'Nunito', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDetail("Speed", "${delivery!.ballSpeed} km/h"),
            _buildDetail("Ball Line", delivery!.ballLine),
            _buildDetail("Ball Length", delivery!.ballLength),
            _buildDetail("Batsman Position", delivery!.batsmanPosition == 1 ? "Left Handed" : "Right Handed"),

            const SizedBox(height: 30),
            if (isCoach) _buildFeedbackSection(),

            const SizedBox(height: 30),
            const Text(
              "Ideal Shot Recommendation",
              style: TextStyle(fontFamily: 'Nunito', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...delivery!.idealShots.take(5).map((shot) => _buildShotCard(shot)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Coach Feedback",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        const SizedBox(height: 8),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white, fontFamily: 'Nunito'),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter your feedback...",
            hintStyle: TextStyle(color: Colors.white70),
            fillColor: AppColors.secondary,
            filled: true,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Batting Rating (1–10):",
          style: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
        ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: isSubmitting
                ? const CircularProgressIndicator()
                : const Text("Submit Feedback", style: TextStyle(fontFamily: 'Nunito', color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildShotCard(IdealShot shot) {
    return Center(
      child: Card(
        color: AppColors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                shot.shot,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Confidence Score",
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Nunito',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              DonutChart(accuracy: shot.confidenceScore, radius: 80),
              const SizedBox(height: 16),
              if (shotGifMap.containsKey(shot.shot.trim()))
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: shotGifMap[shot.shot.trim()]!,
                    placeholder: (context, url) => const SizedBox(
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      height: 150,
                      child: Center(child: Icon(Icons.error, color: Colors.red, size: 40)),
                    ),
                    width: 300,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
