import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project_sandbox/bloc/app_bloc.dart';
import 'package:test_project_sandbox/components/radio_button_widget.dart';
import 'package:test_project_sandbox/model/currency_model.dart';
import 'package:test_project_sandbox/utils/formatters.dart';

import '../bloc/app_state.dart';

/// Кастомный ТекстФилд

class TextFieldWithDropDown extends StatefulWidget {
  String labelText;
  bool readOnly;
  TextEditingController controller;
  CurrencyModel? activeCurrency;
  Function(CurrencyModel) onAccept;
  Function(String)? onChanged;

  TextFieldWithDropDown({
    required this.labelText,
    required this.controller,
    required this.onAccept,
    required this.activeCurrency,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  _TextFieldWithDropDownState createState() => _TextFieldWithDropDownState();
}

class _TextFieldWithDropDownState extends State<TextFieldWithDropDown> {
  CurrencyModel? currentActiveCurrency;

  @override
  void initState() {
    super.initState();
    currentActiveCurrency = CurrencyModel(
      value: widget.activeCurrency?.value,
      name: widget.activeCurrency?.name,
      id: widget.activeCurrency?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 260,
          child: TextField(
            readOnly: widget.readOnly,
            controller: widget.controller,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            inputFormatters: [
              DecimalTextInputFormatter(decimalRange: 2),
            ],
            decoration: InputDecoration(
              labelText: widget.labelText,
            ),
          ),
        ),
        SizedBox(
          child: Text(currentActiveCurrency?.name ?? ''),
        ),
        InkWell(
          child: Icon(Icons.keyboard_arrow_down_sharp),
          onTap: () => showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context1, setState1) => Dialog(
                child: BlocBuilder<AppBloc, AppState>(
                  builder: (context, state) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text('Choose a currency'),
                      ),
                      SizedBox(
                        height: 450,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: state.currencies != null
                                  ? state.currencies!
                                  .map((e) => RadioButtonWidget(
                                  isActive: currentActiveCurrency?.name ==
                                      e.name,
                                  currency: e,
                                  onTap: (value) => setState1(() {
                                    currentActiveCurrency = value;
                                  })))
                                  .toList()
                                  : [],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 150,
                              height: 45,
                              child: Center(
                                child: Text('Cancel'),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (currentActiveCurrency != null) {
                                widget.onAccept(currentActiveCurrency!);
                              }
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 45,
                              width: 150,
                              child: Center(
                                child: Text('Ok'),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
