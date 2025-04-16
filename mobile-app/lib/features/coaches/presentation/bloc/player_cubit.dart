import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/usecases/get_players_usecase.dart';
import 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final GetPlayersUseCase getPlayersUseCase;

  PlayerCubit({required this.getPlayersUseCase}) : super(PlayerInitial());

  Future<void> fetchPlayers(String coachUid) async {
    emit(PlayerLoading());
    try {
      final players = await getPlayersUseCase.call(coachUid);
      emit(PlayerLoaded(players));
    } catch (e) {
      emit(PlayerError('Failed to fetch players'));
    }
  }
}
