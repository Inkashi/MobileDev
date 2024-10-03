import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  static const List<String> list = ['гр', 'кг', 'т'];
  String? _dropIndex = list.first;
  String input = '';

  double convert(String input, String currentType) {
    double? value = double.tryParse(input);
    print(currentType == list[2]);
    if (value == null) {
      return 0;
    }
    if (_dropIndex == currentType) {
      return value;
    } else if (currentType == list[0]) {
      if (_dropIndex == list[1]) {
        value *= 1000;
      } else {
        value *= 1000000;
      }
    } else if (currentType == list[1]) {
      if (_dropIndex == list[0]) {
        value /= 1000;
      } else {
        value *= 1000;
      }
    } else {
      if (_dropIndex == list[0]) {
        value /= 1000000;
      } else {
        value /= 1000;
      }
    }
    return double.parse(value.toStringAsFixed(6));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 40, left: 40),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^-?\d*\.?\d*'),
                        ),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          String newText = newValue.text;
                          if (newText.split('.').length > 2 ||
                              newText.indexOf('.') == 0) {
                            return oldValue;
                          }
                          if (newText.contains('-') &&
                              newText.indexOf('-') != 0) {
                            return oldValue;
                          }
                          return newValue;
                        }),
                      ],
                      onChanged: (text) {
                        setState(() {
                          input = text;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    dropdownColor: Colors.deepPurple,
                    value: _dropIndex,
                    onChanged: (String? value) {
                      setState(() {
                        _dropIndex = value;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${convert(input, 'гр')} гр'),
                Text('${convert(input, 'кг')} кг'),
                Text('${convert(input, 'т')} т'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
