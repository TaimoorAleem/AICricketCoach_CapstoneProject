import '../../domain/entities/player.dart';

abstract class PlayerState {}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerLoaded extends PlayerState {
  final List<Player> players;
  PlayerLoaded(this.players);
}

class PlayerError extends PlayerState {
  final String message;
  PlayerError(this.message);
}
