import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calc(),
    );
  }
}

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  var input = '';
  var hasDecimal = false;
  var hasOperator = false;
  var isAns = false;

  final List<String> CalcDisplay = [
    'C',
    '^',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'SQR',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 76, 0, 148),
      body: Column(children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 38, 255),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(input,
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white60)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: GridView.builder(
              itemCount: CalcDisplay.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CalcButton(
                    buttonText: CalcDisplay[index],
                    color: buttonColor(index),
                    textColor: Colors.white,
                    buttonTap: () {
                      setState(() {
                        if (isAns) {
                          input = '';
                          hasDecimal = false;
                          isAns = false;
                          hasOperator = false;
                          CalcDisplay[0] = 'C';
                        } else {
                          if (input.length != 0) {
                            if (isOperator(input[input.length - 1])) {
                              hasOperator = false;
                            }
                          }
                          input = input.substring(
                              0, input.length > 0 ? input.length - 1 : 0);
                          if (input.length == 0) {
                            hasOperator = false;
                          }
                        }
                      });
                    },
                  );
                } else if (index == CalcDisplay.length - 1) {
                  return CalcButton(
                    buttonText: CalcDisplay[index],
                    color: buttonColor(index),
                    textColor: Colors.white,
                    buttonTap: () {
                      setState(() {
                        getAnswer();
                        isAns = true;
                        CalcDisplay[0] = 'AC';
                      });
                    },
                  );
                } else if (CalcDisplay[index] == 'SQR') {
                  return CalcButton(
                    buttonText: CalcDisplay[index],
                    color: buttonColor(index),
                    textColor: Colors.white,
                    buttonTap: () {
                      setState(() {
                        if (input.isNotEmpty) {
                          RegExp negativeNumber = RegExp(
                              r'^(-[0-9]*)$'); //если это отрицательное число
                          RegExp getLastNumber = RegExp(
                              r'[+\-x/%^]'); //если дан пример [2-2] то последняя из последней двойки извлечется корень
                          if (negativeNumber.hasMatch(input)) {
                            //из  отрицательных чисел нельзя извлечь корень
                            input = 'Ошибка';
                          } else {
                            Iterable<RegExpMatch> matches =
                                getLastNumber.allMatches(input);
                            if (matches.isNotEmpty) {
                              int lastIndex = matches.last.start;
                              var stringlast = input.substring(lastIndex + 1);
                              input = input.substring(0, lastIndex + 1);
                              double number = double.parse(stringlast);
                              input = input +
                                  sqrt(number)
                                      .toString()
                                      .replaceAll(RegExp(r'\.0'), '');
                            } else {
                              input = sqrt(double.parse(input))
                                  .toString()
                                  .replaceAll(RegExp(r'\.0'), '');
                            }
                          }
                          isAns = true;
                          CalcDisplay[0] = 'AC';
                        }
                      });
                    },
                  );
                } else if (CalcDisplay[index] == '.') {
                  return CalcButton(
                    buttonText: CalcDisplay[index],
                    color: buttonColor(index),
                    textColor: Colors.white,
                    buttonTap: () {
                      setState(() {
                        if (!input.contains('.')) {
                          hasDecimal = false;
                        }
                        if (input.isNotEmpty &&
                            !hasDecimal &&
                            !isOperator(input[input.length - 1])) {
                          input += CalcDisplay[index];
                          hasDecimal = true;
                        }
                        if (isAns) {
                          isAns = false;
                          input = '0.';
                        }
                      });
                    },
                  );
                } else {
                  return CalcButton(
                    buttonText: CalcDisplay[index],
                    color: buttonColor(index),
                    textColor: Colors.white,
                    buttonTap: () {
                      setState(() {
                        if (isOperator(CalcDisplay[index])) {
                          if (!hasOperator) {
                            if (input.isEmpty) {
                              if (CalcDisplay[index] == '-') {
                                input += CalcDisplay[index];
                              }
                            } else {
                              input += CalcDisplay[index];
                            }
                          }
                          hasDecimal = false;
                          hasOperator = true;
                          isAns = false;
                          CalcDisplay[0] = 'C';
                        } else {
                          if (!isAns) {
                            hasOperator = false;
                            input += CalcDisplay[index];
                          } else {
                            isAns = false;
                            hasDecimal = false;
                            input = CalcDisplay[index];
                          }
                        }
                      });
                    },
                  );
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  // Проверка на оператор
  bool isOperator(String x) {
    final isnumber = RegExp(r'^[0-9]');
    if (!isnumber.hasMatch(x) && x != '.') {
      return true;
    } else {
      return false;
    }
  }

  Color buttonColor(index) {
    return isOperator(CalcDisplay[index])
        ? Colors.blueAccent
        : const Color.fromARGB(255, 140, 111, 185);
  }

  // Метод для получения ответа
  void getAnswer() {
    if (input.length == 0) {
      input = '0';
      return;
    }
    if (input.length > 0) {
      if (isOperator(input[input.length - 1])) {
        input = input.substring(0, input.length - 1);
      }
    }
    String parseTask = input;
    if (parseTask.isEmpty) {
      return;
    }
    parseTask = parseTask.replaceAll('x', '*');
    if (parseTask.contains('/0')) {
      input = 'Деление на ноль';
      return;
    }
    Parser p = Parser();
    Expression exp = p.parse(parseTask);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    hasDecimal = true;
    input = eval.toString().replaceAll(RegExp(r'\.0$'), '');
  }
}

//Класс кнопки
class CalcButton extends StatefulWidget {
  final color;
  final textColor;
  final String buttonText;
  final buttonTap;

  const CalcButton(
      {super.key,
      this.color,
      this.textColor,
      this.buttonText = '',
      this.buttonTap});

  @override
  _CalcButtonState createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  var _buttonColor;

  @override
  void initState() {
    super.initState();
    _buttonColor = widget.color;
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _buttonColor = Colors.lightBlue;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _buttonColor = widget.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.buttonTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 5),
          decoration: BoxDecoration(
            color: _buttonColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.buttonText,
              style: TextStyle(color: widget.textColor, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
