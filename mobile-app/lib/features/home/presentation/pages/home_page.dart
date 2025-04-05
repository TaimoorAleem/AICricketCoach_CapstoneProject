import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/app_colors.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../sessions/presentation/pages/sessions_history_page.dart';
import '../../../user_profile/presentation/pages/user_profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<String?> _getPlayerUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home')),
        backgroundColor: AppColors.secondary,
      ),
      body: FutureBuilder<String?>(
        future: _getPlayerUid(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final playerUid = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavButton(
                  label: 'User Profile',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfilePage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildNavButton(
                  label: 'Sessions History',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionsHistoryPage(playerId: playerUid),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildNavButton(
                  label: 'Analytics',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalyticsPage.singlePlayer(playerUid: playerUid),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
