import 'package:flutter/material.dart';
import 'package:test_project_sandbox/model/currency_model.dart';

/// Кастомный RadioButton
class RadioButtonWidget extends StatelessWidget {
  RadioButtonWidget(
      {required this.isActive,
      required this.currency,
      required this.onTap,
      });

  bool isActive;
  CurrencyModel currency;
  Function(CurrencyModel) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(currency),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.deepPurple : Colors.transparent,
                border: Border.all(color: Colors.black12),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(currency.name ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
