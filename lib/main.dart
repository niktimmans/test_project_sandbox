import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project_sandbox/bloc/app_bloc.dart';
import 'package:test_project_sandbox/bloc/app_event.dart';
import 'package:test_project_sandbox/components/text_field_with_drop_down.dart';
import 'package:test_project_sandbox/repository/app_repository.dart';

import 'bloc/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AppRepository()..init(),
      child: BlocProvider(
        create: (context) => AppBloc(
          repository: context.read<AppRepository>(),
        )..add(InitAppEvent()),
        child: MaterialApp(
          title: 'Currency converter',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency converter'),
      ),
      body: Center(
        child: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state is ReadyAppState) {
              if (state.result != null) {
                toController.text = state.result.toString();
              }
            }
          },
          builder: (context, state) => (state is ReadyAppState)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFieldWithDropDown(
                      labelText: 'You send',
                      controller: fromController,
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          context
                              .read<AppBloc>()
                              .add(UpdateFromEvent(from: double.parse(value)));
                        }
                      },
                      onAccept: (currencyModel) {
                        context
                            .read<AppBloc>()
                            .add(ChooseFromCurrency(from: currencyModel));
                      },
                      activeCurrency: state.fromCurrency,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          context.read<AppBloc>().add(ConvertEvent());
                        },
                        child: Icon(Icons.import_export),
                      ),
                    ),
                    TextFieldWithDropDown(
                      labelText: 'They get',
                      readOnly: true,
                      controller: toController,
                      onAccept: (currencyModel) {
                        context
                            .read<AppBloc>()
                            .add(ChooseToCurrency(to: currencyModel));
                      },
                      activeCurrency: state.toCurrency,
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
