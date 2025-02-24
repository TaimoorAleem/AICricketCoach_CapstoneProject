import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_players_usecase.dart';
import 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final GetPlayersUseCase getPlayersUseCase;

  PlayerCubit({required this.getPlayersUseCase}) : super(PlayerInitial());

  Future<void> getPlayers(String coachUid) async {
    emit(PlayerLoading());
    final result = await getPlayersUseCase.call(coachUid);
    result.fold(
          (error) => emit(PlayerError(error)),
          (players) => emit(PlayerLoaded(players)),
    );
  }
}
