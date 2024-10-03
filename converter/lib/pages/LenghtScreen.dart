import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LenghtScreen extends StatefulWidget {
  const LenghtScreen({super.key});

  @override
  State<LenghtScreen> createState() => _LenghtScreenState();
}

class _LenghtScreenState extends State<LenghtScreen> {
  static const List<String> list = ['мм', 'см', 'м'];
  String? _dropIndex = list.first;
  String input = '';

  double convert(String input, String currentType) {
    double? value = double.tryParse(input);
    if (value == null) {
      return 0;
    }

    if (_dropIndex == currentType) {
      return value;
    } else if (currentType == list[0]) {
      if (_dropIndex == list[1]) {
        value *= 10;
      } else {
        value *= 1000;
      }
    } else if (currentType == list[1]) {
      if (_dropIndex == list[0]) {
        value /= 10;
      } else {
        value *= 100;
      }
    } else {
      if (_dropIndex == list[0]) {
        value /= 1000;
      } else {
        value /= 100;
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
                Text('${convert(input, 'мм')} мм'),
                Text('${convert(input, 'см')} см'),
                Text('${convert(input, 'м')} м'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
