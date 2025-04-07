import 'package:ai_cricket_coach/features/home/presentation/pages/sessions_manager_page.dart';
import 'package:ai_cricket_coach/features/video_upload/presentation/pages/upload_video.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_cricket_coach/features/analytics/presentation/pages/analytics_page.dart';
import '../../../../resources/app_colors.dart';
import '../../../sessions/presentation/pages/sessions_history_page.dart';
import '../../../user_profile/presentation/pages/user_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? playerUid;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadUid();
  }

  Future<void> _loadUid() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null) {
      setState(() {
        playerUid = uid;
        _pages = [
          SessionsHistoryPage(playerId: uid),
          UploadVideoPage(),
        ];
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (playerUid == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.secondary),
              child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Sessions History'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SessionsHistoryPage(playerId: playerUid!)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Analytics Page'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AnalyticsPage.singlePlayer(playerUid: playerUid!)));
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sports_cricket), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
