import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../user_profile/presentation/pages/user_profile_page.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/usecases/get_players_usecase.dart';
import 'player_list_page.dart';

class CoachHomePage extends StatefulWidget {
  const CoachHomePage({Key? key}) : super(key: key);

  @override
  State<CoachHomePage> createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {
  int _selectedIndex = 0;
  List<PlayerEntity> _players = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final coachUid = prefs.getString('uid');
    if (coachUid == null) return;

    final getPlayersUseCase = Provider.of<GetPlayersUseCase>(context, listen: false);
    final result = await getPlayersUseCase(coachUid);

    setState(() {
      _players = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> _pages = [
      UserProfilePage(),
      PlayerListPage(players: _players),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Players'),
        ],
      ),
    );
  }
}