import 'package:flutter/material.dart';
import '../../../sessions/presentation/pages/sessions_history_page.dart';
import '../../domain/entities/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool compareMode;
  final bool isSelected;
  final Function(bool?) onSelect;

  const PlayerCard({
    super.key,
    required this.player,
    this.compareMode = false,
    this.isSelected = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: compareMode
          ? _buildCheckboxTile()
          : _buildDefaultCard(context),
    );
  }

  Widget _buildDefaultCard(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: player.pfpUrl.isNotEmpty ? NetworkImage(player.pfpUrl) : null,
        child: player.pfpUrl.isEmpty ? const Icon(Icons.person) : null,
      ),
      title: Text("${player.firstName} ${player.lastName}"),
      subtitle: Text(player.teamName.isNotEmpty ? player.teamName : "No Team"),
      trailing: ElevatedButton(
        onPressed: () {
          // ✅ Pass player UID when navigating
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionsHistoryPage(playerUid: player.uid),
            ),
          );
        },
        child: const Text("Recent Sessions"),
      ),
    );
  }

  Widget _buildCheckboxTile() {
    return CheckboxListTile(
      title: Text("${player.firstName} ${player.lastName}"),
      subtitle: Text(player.teamName.isNotEmpty ? player.teamName : "No Team"),
      value: isSelected,
      onChanged: onSelect,
    );
  }
}
