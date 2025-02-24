import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/usecases/predict_shot_usecase.dart';
import '../../domain/entities/shot_prediction.dart';
import '../widgets/donut_chart.dart';

class IdealShotPage extends StatefulWidget {
  final PredictShotUseCase predictShot;

  const IdealShotPage({super.key, required this.predictShot});

  @override
  State<IdealShotPage> createState() => _IdealShotPageState();
}

class _IdealShotPageState extends State<IdealShotPage> {
  ShotPrediction? prediction;
  bool isLoading = true;
  String? errorMessage;

  final Map<String, dynamic> ballMetrics = {
    "Ball Speed": 85,
    "Batsman Position": 0,
    "Ball Horizontal Line": "middle stump",
    "Ball Length": "full pitched"
  };

  final Map<String, String> shotGifMap = {
    "Pull Shot": "https://media2.giphy.com/media/BzJVPvZ7WP048mVtXH/200w.gif?cid=6c09b952po1ypwa37u2w63jmyjujwr9h1ywj7895a483ao3b&ep=v1_gifs_search&rid=200w.gif&ct=g",
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
    "Drive Off": "https://s4.ezgif.com/tmp/ezgif-49af1fe0603f91.gif",
    "Lofted Off Drive": "https://media.tenor.com/B6jLPhW2krUAAAAM/bhibatsam-shubam-gill.gif",
    "Lofted Drive On": "https://cricketforbegginer.wordpress.com/wp-content/uploads/2014/04/40715902_back_drive_anim.gif",
    "Square Cut": "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExZHd4cWNvdzU1djdveHphNHp0aWlhbnFpbXB3dW5kZGQ3dmI0bTc3bSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/yDjgHGTbmuxLC3RxaW/giphy.gif",
    "Back-Foot Leg Glance": "https://newsimg.bbc.co.uk/media/images/41958000/gif/_41958468_bf_leg_glance_416x300.gif",
    "Drive Cover": "https://media.tenor.com/k3xsAvK7IIIAAAAM/signature-shot-virat-kohli.gif",
    "Cut": "https://i.makeagif.com/media/9-04-2015/6oubYp.gif",
    "Reverse Sweep": "https://i.makeagif.com/media/7-24-2015/WEcNFE.gif",
    "Lofted On Drive": "https://s4.ezgif.com/tmp/ezgif-44d43b44537142.gif",
    "Drive On": "https://www.stancebeam.com/assets/images/blog/on-drive-sikana-english.gif",
    "Lofted Straight Drive": "https://s4.ezgif.com/tmp/ezgif-44d43b44537142.gif"
  };

  @override
  void initState() {
    super.initState();
    _fetchPrediction();
  }

  Future<void> _fetchPrediction() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await widget.predictShot.call(ballMetrics);
      setState(() {
        prediction = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ideal Shot Recommendation')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildSuccessState(),
    );
  }

  Widget buildSuccessState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Display Ball Metrics Table
          _buildBallMetricsTable(),

          const SizedBox(height: 20),

          // Display Shot Predictions
          ...prediction!.shots.map((shot) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  // ✅ Display Shot Name ONLY (No Percentage)
                  Text(
                    shot.shot,  // ✅ Removed percentage
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Display Donut Chart with Confidence Level
                  DonutChart(accuracy: shot.confidenceScore),

                  const SizedBox(height: 10),

                  // Display GIF if available
                  if (shotGifMap.containsKey(shot.shot.trim()))
                    CachedNetworkImage(
                      imageUrl: shotGifMap[shot.shot.trim()]!,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                      width: 250,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }


  Widget _buildBallMetricsTable() {
    return Table(
      border: TableBorder.all(color: Colors.white),
      children: ballMetrics.entries.map((entry) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(entry.value.toString()),
            ),
          ],
        );
      }).toList(),
    );
  }
}
