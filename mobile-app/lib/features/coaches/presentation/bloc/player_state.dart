import '../../domain/entities/player_entity.dart';

abstract class PlayerState {}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerLoaded extends PlayerState {
  final List<PlayerEntity> players;

  PlayerLoaded(this.players);
}

class PlayerError extends PlayerState {
  final String message;

  PlayerError(this.message);
}
