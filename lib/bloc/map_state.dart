part of 'map_bloc.dart';

@immutable
sealed class MapState {}

class MapInitial extends MapState {}
class MapLoading extends MapState {}
class MapCalculated extends MapState {
  MapCalculated(this.x, this.y, this.url);

  final int x;
  final int y;
  final String url;
}
class MapError extends MapState {
  MapError(this.title);
  final String title;
}
