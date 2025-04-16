import 'package:flutter/material.dart';
import '../../domain/entities/player_entity.dart';

class PlayerCard extends StatelessWidget {
  final PlayerEntity player;
  final bool isSelected;
  final bool showCheckbox;
  final VoidCallback onTap;

  const PlayerCard({
    Key? key,
    required this.player,
    required this.isSelected,
    required this.onTap,
    this.showCheckbox = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: player.pfpUrl != null && player.pfpUrl!.isNotEmpty
              ? NetworkImage(player.pfpUrl!)
              : null,
          child: player.pfpUrl == null || player.pfpUrl!.isEmpty
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text('${player.firstName} ${player.lastName}'),
        subtitle: Text(player.teamName ?? 'No Team'),
        trailing: showCheckbox
            ? Checkbox(
          value: isSelected,
          onChanged: (_) => onTap(),
        )
            : (isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null),
      ),
    );
  }
}
