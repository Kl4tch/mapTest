import 'dart:async';
import 'dart:math' as mp;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<InitEvent>((event, emit) {});
    on<StartEvent>((event, emit) {
      start();
    });
    on<DismissEvent>((event, emit) {
      emit(MapInitial());
    });
  }


  final latC = TextEditingController();
  final lngC = TextEditingController();
  final zoomC = TextEditingController();


  void start() {
    try {
      final double lat = double.parse(latC.text);
      final double lng = double.parse(lngC.text);
      final double zoom = double.parse(zoomC.text);

      final input = Input(lat, lng, zoom);
      (int x, int y) result = _getTile(input);

      String url = "https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles?l=carparks&x=${result.$1}&y=${result.$2}&z=$zoom&scale=1&lang=ru_RU";
      // String url = "https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles?l=carparks&x=316898&y=164368&z=19&scale=1&lang=ru_RU";

      emit(MapCalculated(result.$1, result.$2, url));
    }
    catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void test() {
    final input = Input(55.786889, 37.617747, 16);
    print(_getTile(input));
  }

  (int x, int y) _getTile(Input input) {
    double latRad = _degreeToRadian(input.lat);
    num n = mp.pow(2.0, input.zoom);

    int xTile = (n * ((input.lng + 180.0) / 360.0)).floor();
    int yTile = ((1.0 - mp.log(mp.tan(latRad) + 1.0 / mp.cos(latRad)) / mp.pi) / 2.0 * n).floor();

    return (xTile, yTile);
  }

  double _degreeToRadian(double degree) {
    return degree * (mp.pi / 180);
  }

}

class Input {
  Input(this.lat, this.lng, this.zoom);
  double lat;
  double lng;
  double zoom;
}
