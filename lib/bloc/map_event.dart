part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}
class StartEvent implements MapEvent {}
class InitEvent implements MapEvent {}
