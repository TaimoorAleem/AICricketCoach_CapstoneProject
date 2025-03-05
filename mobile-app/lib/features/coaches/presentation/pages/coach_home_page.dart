import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_players_usecase.dart';
import '../bloc/PlayerCubit.dart';
import '../bloc/player_state.dart';
import '../widgets/PlayerCard.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';

class CoachHomePage extends StatefulWidget {
  final String coachUid;

  const CoachHomePage({super.key, required this.coachUid});

  @override
  _CoachHomePageState createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {
  final Set<String> selectedPlayers = {}; // ✅ Stores selected player UIDs
  bool compareMode = false; // ✅ Track if compare mode is active

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayerCubit(getPlayersUseCase: context.read<GetPlayersUseCase>())..getPlayers(widget.coachUid),
      child: Scaffold(
        appBar: AppBar(title: const Text("Coach Dashboard")),
        body: Column(
          children: [
            // ✅ Compare Players Button (always visible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    compareMode = !compareMode; // ✅ Toggle compare mode
                    selectedPlayers.clear(); // ✅ Reset selected players
                  });
                },
                child: Text(compareMode ? "Cancel Compare" : "Compare Players"),
              ),
            ),

            // ✅ Player List (Cards or Checkboxes)
            Expanded(
              child: BlocBuilder<PlayerCubit, PlayerState>(
                builder: (context, state) {
                  if (state is PlayerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PlayerError) {
                    return Center(child: Text(state.message));
                  } else if (state is PlayerLoaded) {
                    return ListView(
                      children: state.players.map((player) {
                        return PlayerCard(
                          player: player,
                          compareMode: compareMode, // ✅ Switch mode dynamically
                          isSelected: selectedPlayers.contains(player.uid), // ✅ Check if selected
                          onSelect: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                if (selectedPlayers.length < 2) {
                                  selectedPlayers.add(player.uid);
                                }
                              } else {
                                selectedPlayers.remove(player.uid);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  }
                  return const Center(child: Text("No players available."));
                },
              ),
            ),

            // ✅ "Compare Players" Button (Only visible when 2 players are selected)
            if (compareMode)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: selectedPlayers.length == 2
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalyticsPage.comparePlayers(
                          playerUid1: selectedPlayers.first,
                          playerUid2: selectedPlayers.last,
                        ),
                      ),
                    );
                  }
                      : null, // Disable button until 2 players are selected
                  child: const Text("Compare Selected Players"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
