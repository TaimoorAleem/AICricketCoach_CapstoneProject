import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../resources/app_colors.dart';
import '../../domain/entities/ideal_shot.dart';
import '../widgets/donut_chart.dart';

class IdealShotPage extends StatelessWidget {
  final Map<String, dynamic> ballCharacteristics;
  final List<IdealShot> shots;

  const IdealShotPage({
    super.key,
    required this.ballCharacteristics,
    required this.shots,
  });

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ideal Shot Recommendation',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        backgroundColor: AppColors.background,
      ),
      body: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ball Metrics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 16),
              _buildBallMetricsTable(),
              const SizedBox(height: 32),
              const Text(
                'Recommended Shot(s):',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...shots.take(5).map((shot) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          shot.shot,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        DonutChart(accuracy: shot.confidenceScore),
                        const SizedBox(height: 20),
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
                                child: Center(
                                  child: Icon(Icons.error, color: Colors.red, size: 40),
                                ),
                              ),
                              width: 300,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBallMetricsTable() {
    return Table(
      border: TableBorder.all(
        color: Colors.grey[300]!,
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      children: ballCharacteristics.entries.map((entry) {
        return TableRow(
          decoration: const BoxDecoration(color: AppColors.secondary),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                entry.value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
