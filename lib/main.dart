import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/map_bloc.dart';

void main() {
  // input: https://yandex.ru/maps/geo/moskva/53166393/?l=carparks&ll=37.617747%2C55.786889&z=16
  // out = https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles?l=carparks&x=316898&y=164368&z=19&scale=1&lang=ru_RU

  // input: lat = 55.786889, lng = 37.617747, z = 16
  // out = x=316898, y=164368
  // final bloc = MapBloc();
  // print(bloc.getTile(Input(55.786889, 37.617747, 16)));
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => MapBloc(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const WindowWidget(),
        )
    );
  }
}

class WindowWidget extends StatelessWidget {
  const WindowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Карты")),
      body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return switch (state) {
              MapInitial _ => const _FormWidget(),
              MapCalculated s => _CalculatedWidget(state: s),
              MapError e => Text(e.title)
            };
          }
      )
    );
  }
}

class _CalculatedWidget extends StatelessWidget {
  const _CalculatedWidget({super.key, required this.state});
  final MapCalculated state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _FormWidget(),
        Text("x = ${state.x}"),
        Text("y = ${state.y}"),
      ],
    );
  }
}


class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    return Center(
        child: SizedBox(
            width: 300,
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                        child: Column(children: [
                          TextFormField(
                            decoration: getInputDecorator('Lat'),
                            controller: bloc.latC,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                            onFieldSubmitted: (input) {

                            },
                          ),
                          TextFormField(
                            decoration: getInputDecorator('Lng'),
                            controller: bloc.lngC,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                            onFieldSubmitted: (input) {

                            },
                          ),
                          TextFormField(
                            decoration: getInputDecorator('zoom'),
                            controller: bloc.zoomC,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                            onFieldSubmitted: (input) {

                            },
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: () {
                              bloc.add(StartEvent());
                            },
                            child: const Text('Start'),
                          )
                        ]
                        )
                    )
                )
            )
        )
    );
  }
}

InputDecoration getInputDecorator(String label) {
  return InputDecoration(
    labelText: label,
    enabledBorder: const UnderlineInputBorder(),
    focusedBorder: const UnderlineInputBorder(),
  );
}
