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
  final Set<String> selectedPlayers = {};
  bool compareMode = false;

  // TODO: User Profile Button
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayerCubit(getPlayersUseCase: context.read<GetPlayersUseCase>())..getPlayers(widget.coachUid),
      child: Scaffold(
        appBar: AppBar(title: const Text("Coach Dashboard")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    compareMode = !compareMode;
                    selectedPlayers.clear();
                  });
                },
                child: Text(compareMode ? "Cancel Compare" : "Compare Players"),
              ),
            ),

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
                          compareMode: compareMode,
                          isSelected: selectedPlayers.contains(player.uid),
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
