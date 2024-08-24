import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Calculator App'),
    );
  }
}

enum BtnCalculate {
  clear("AC"), negative("-/+"), percent("%"), div("÷"),
  seven("7"), eight("8"), nine("9"), mul("x"),
  four("4"), five("5"), six("6"), sub("-"),
  one("1"), two("2"), three("3"), add("+"),
  zero("0"), decimal("."), equal("=");

  final String value;
  const BtnCalculate(this.value);

  Color get buttonColor {
    switch (this) {
      case add:
      case sub:
      case mul:
      case div:
      case equal:
        return Colors.orange;
      case clear:
      case negative:
      case percent:
        return Colors.grey.shade300;
      default:
        return Colors.grey.shade700;
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _value = '0';
  int _runningNumber = 0;
  BtnCalculate? _currentOperation;
  BtnCalculate? _highlightedButton;

  final List<List<BtnCalculate>> _arrButtons = [
    [BtnCalculate.clear, BtnCalculate.negative, BtnCalculate.percent, BtnCalculate.div],
    [BtnCalculate.seven, BtnCalculate.eight, BtnCalculate.nine, BtnCalculate.mul],
    [BtnCalculate.four, BtnCalculate.five, BtnCalculate.six, BtnCalculate.sub],
    [BtnCalculate.one, BtnCalculate.two, BtnCalculate.three, BtnCalculate.add],
    [BtnCalculate.zero, BtnCalculate.decimal, BtnCalculate.equal],
  ];

  void _onButtonPressed(BtnCalculate button) {
    setState(() {
      if (button == BtnCalculate.add || button == BtnCalculate.sub ||
          button == BtnCalculate.mul || button == BtnCalculate.div) {
        _highlightedButton = button;
        _setOperation(button);
      } else if (button == BtnCalculate.equal) {
        _calculateResult();
        _highlightedButton = null;
      } else if (button == BtnCalculate.clear) {
        _clearCalculator();
      } else {
        _handleNumberInput(button.value);
      }
    });
  }

  void _setOperation(BtnCalculate button) {
    if (button == BtnCalculate.add) {
      _currentOperation = BtnCalculate.add;
    } else if (button == BtnCalculate.sub) {
      _currentOperation = BtnCalculate.sub;
    } else if (button == BtnCalculate.mul) {
      _currentOperation = BtnCalculate.mul;
    } else if (button == BtnCalculate.div) {
      _currentOperation = BtnCalculate.div;
    }

    _runningNumber = int.tryParse(_value) ?? 0;
    _value = '0';
  }

  void _calculateResult() {
    final runningValue = _runningNumber;
    final currentValue = int.tryParse(_value) ?? 0;
    if (_currentOperation case BtnCalculate.add) {
      _value = '${runningValue + currentValue}';
    } else if (_currentOperation case BtnCalculate.sub) {
      _value = '${runningValue - currentValue}';
    } else if (_currentOperation case BtnCalculate.mul) {
      _value = '${runningValue * currentValue}';
    } else if (_currentOperation case BtnCalculate.div) {
      _value = '${runningValue ~/ currentValue}';
    } else if (_currentOperation case null) {
    } else if (_currentOperation case BtnCalculate.clear || BtnCalculate.negative) {
    }
    _currentOperation = null;
  }

  void _clearCalculator() {
    _value = '0';
    _runningNumber = 0;
    _currentOperation = null;
    _highlightedButton = null;
  }

  void _handleNumberInput(String number) {
    if (_value == '0') {
      _value = number;
    } else {
      _value += number;
    }
  }

  Color _backgroundColor(BtnCalculate button) {
    return button == _highlightedButton
        ? button.buttonColor.withOpacity(0.5)
        : button.buttonColor;
  }

  double _buttonWidth(BtnCalculate button) {
    if (button == BtnCalculate.zero) {
      return ((MediaQuery.of(context).size.width - (5 * 12)) / 2 )-15;
    }
    if(button == BtnCalculate.clear || button == BtnCalculate.negative || button == BtnCalculate.percent) {
      return ((MediaQuery.of(context).size.width - (5 * 12)) / 2 )-100;

    }
    return ((MediaQuery.of(context).size.width - (5 * 12)) / 4)-25;
  }

  double _buttonHeight() {
    return ((MediaQuery.of(context).size.width - (5 * 12)) / 4) - 15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
        
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(
              _value,
              style: TextStyle(fontSize: 80, color: Colors.white),
            ),
          ),
         
          Column(
            children: <Widget>[
              for (var row in _arrButtons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (var item in row)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _backgroundColor(item),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_buttonWidth(item) / 1),
                            ),
                            minimumSize: Size(_buttonWidth(item), _buttonHeight()),
                          ),
                          onPressed: () => _onButtonPressed(item),
                          child: Text(
                            item.value,
                            style: TextStyle(fontSize: (item.value == "AC" || item.value == "-/+" || item.value == "%") ? 20 : 30, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
