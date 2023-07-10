part of 'map_bloc.dart';

@immutable
sealed class MapState {}

class MapInitial extends MapState {}
class MapCalculated extends MapState {
  MapCalculated(this.x, this.y);

  final int x;
  final int y;
}
class MapError extends MapState {
  MapError(this.title);
  final String title;
}
