// home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_cricket_coach/features/video_upload/presentation/pages/upload_video.dart';
import 'package:ai_cricket_coach/features/sessions/presentation/pages/sessions_history_page.dart';
import 'package:ai_cricket_coach/features/analytics/presentation/pages/analytics_page.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/pages/user_profile_page.dart';
import '../../../../resources/app_colors.dart';
import '../../../video_upload/presentation/pages/sessions_manager_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? playerUid;
  Widget? _overlayPage; // used to stack over current tab
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
          UserProfilePage(),
          UploadVideoPage(
            navigateToTab: _onItemTapped,
            openSessionsManager: _showSessionsManager,
          ),
          SessionsHistoryPage(playerId: uid),
          AnalyticsPage.singlePlayer(
            playerUid: uid,
            useHardcoded: true, // server response was invalid :( Will fix after defense presentation
          ),
        ];
      });
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _overlayPage = null; // close any overlay
    });
  }

  void _showSessionsManager() {
    setState(() {
      _overlayPage = const SessionsManagerPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (playerUid == null || _pages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Cricket Coach'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          if (_overlayPage != null) Positioned.fill(child: _overlayPage!),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Sessions'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),

        ],
      ),
    );
  }
}
