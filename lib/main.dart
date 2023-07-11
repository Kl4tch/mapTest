import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/map_bloc.dart';

void main() {
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
      body: Center(
        child: BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              return switch (state) {
                MapInitial _ => const _FormWidget(),
                MapCalculated s => _CalculatedWidget(state: s),
                MapError e => _ErrorWidget(state: e),
                MapLoading _ => const Center(child: CircularProgressIndicator())
              };
            }
        )
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
        Image.network(state.url),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({super.key, required this.state});
  final MapError state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _FormWidget(),
        Text(state.title),
      ],
    );
  }
}


class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    return SizedBox(
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
                        bloc.add(StartEvent());
                      },
                    ),
                    TextFormField(
                      decoration: getInputDecorator('Lng'),
                      controller: bloc.lngC,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                      onFieldSubmitted: (input) {
                        bloc.add(StartEvent());
                      },
                    ),
                    TextFormField(
                      decoration: getInputDecorator('zoom'),
                      controller: bloc.zoomC,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),],
                      onFieldSubmitted: (input) {
                        bloc.add(StartEvent());
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
