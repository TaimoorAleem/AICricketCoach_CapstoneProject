// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../domain/usecases/get_players_performance_usecase.dart';
// import 'compare_players_state.dart';
//
// class ComparePlayersCubit extends Cubit<ComparePlayersState> {
//   final GetPlayersPerformanceUseCase getPlayersPerformanceUseCase;
//
//   ComparePlayersCubit({required this.getPlayersPerformanceUseCase}) // ✅ Fix: Use named parameter
//       : super(ComparePlayersInitial());
//
//   Future<void> comparePlayers(List<String> playerUids) async {
//     if (playerUids.length != 2) {
//       emit(ComparePlayersError("Please select exactly two players."));
//       return;
//     }
//
//     emit(ComparePlayersLoading());
//
//     final result = await getPlayersPerformanceUseCase.call(playerUids);
//     result.fold(
//           (error) => emit(ComparePlayersError(error)),
//           (performanceData) => emit(ComparePlayersLoaded(performanceData)),
//     );
//   }
// }
