import 'package:flutter/material.dart';
import '../../domain/entities/player_entity.dart';
import '../widgets/player_card.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../sessions/presentation/pages/sessions_history_page.dart';

class PlayerListPage extends StatefulWidget {
  final List<PlayerEntity> players;

  const PlayerListPage({Key? key, required this.players}) : super(key: key);

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  final List<PlayerEntity> selectedPlayers = [];
  bool isSelecting = false;

  void togglePlayerSelection(PlayerEntity player) {
    setState(() {
      if (selectedPlayers.contains(player)) {
        selectedPlayers.remove(player);
      } else if (selectedPlayers.length < 2) {
        selectedPlayers.add(player);
      }
    });
  }

  void handleCardTap(PlayerEntity player) {
    if (isSelecting) {
      togglePlayerSelection(player);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SessionsHistoryPage(playerId: player.uid),
        ),
      );
    }
  }

  void onCompareButtonPressed() {
    if (!isSelecting) {
      // Activate selection mode
      setState(() => isSelecting = true);
    } else if (selectedPlayers.length == 2) {
      // Proceed with comparison
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnalyticsPage.comparePlayers(
            playerUid1: selectedPlayers[0].uid,
            playerUid2: selectedPlayers[1].uid,
          ),
        ),
      ).then((_) {
        // Reset state after returning
        setState(() {
          selectedPlayers.clear();
          isSelecting = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConfirmEnabled = isSelecting && selectedPlayers.length == 2;

    return Scaffold(
      appBar: AppBar(title: const Text('Player List')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                final player = widget.players[index];
                final isSelected = selectedPlayers.contains(player);

                return PlayerCard(
                  player: player,
                  isSelected: isSelected,
                  showCheckbox: isSelecting,
                  onTap: () => handleCardTap(player),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isSelecting && !isConfirmEnabled
                  ? null
                  : onCompareButtonPressed,
              child: Text(isSelecting ? 'Confirm Selection' : 'Compare Performance'),
            ),
          ),
        ],
      ),
    );
  }
}
