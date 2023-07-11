import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  Future<void> start() async {
    try {
      final double lat = double.parse(latC.text);
      final double lng = double.parse(lngC.text);
      final double zoom = double.parse(zoomC.text);

      final input = Input(lat, lng, zoom);
      var pixels = _fromGeoToPixels(input.lat, input.lng, input.zoom);
      var tiles = _fromPixelsToTileNumber(pixels[0], pixels[1]);
      (int x, int y) result = (tiles.$1, tiles.$2);

      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      var start = stringToBase64.decode("aHR0cHM6Ly9jb3JlLWNhcnBhcmtzLXJlbmRlcmVyLWxvdHMubWFwcy55YW5kZXgubmV0L21hcHMtcmRyLWNhcnBhcmtzL3RpbGVzP2w9Y2FycGFya3M=");
      var end = stringToBase64.decode('c2NhbGU9MSZsYW5nPXJ1X1JV');
      String url = "$start&x=${result.$1}&y=${result.$2}&z=${zoom.floor()}&$end";

      final http.Response response = await http.post(Uri.parse(url));
      if(response.statusCode == 200) {
        emit(MapCalculated(result.$1, result.$2, url));
      }
      else {
        emit(MapError("Не найдено"));
      }
    }
    catch (e) {
      emit(MapError(e.toString()));
    }
  }


  (int x, int y) _fromPixelsToTileNumber (int x, int y) {
    return ((x / 256).floor(),
      (y / 256).floor()
    );
  }

  List<int> _fromGeoToPixels(double lat, double long, double z) {
    var e = 0.0818191908426;

    double rho = pow(2, z + 8) / 2;
    double beta = lat * pi / 180;
    double phi = (1 - e * sin(beta)) / (1 + e * sin(beta));
    double theta = tan(pi / 4 + beta / 2) * pow(phi, e / 2);

    int xP = (rho * (1 + long / 180)).floor();
    int yP = (rho * (1 - log(theta) / pi)).floor();

    return [xP, yP];
  }
}

class Input {
  Input(this.lat, this.lng, this.zoom);
  double lat;
  double lng;
  double zoom;
}
