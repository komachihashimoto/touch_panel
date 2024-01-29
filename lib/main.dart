import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'touch panel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _time = 30;
  int _randomCell = Random().nextInt(9);
  int _previousCell = -1;
  Timer? _timer;

  void _incrementCounter() {
    setState(() {
      _counter++;
      do {
        _randomCell = Random().nextInt(9);
      } while (_randomCell == _previousCell);
      _previousCell = _randomCell;

      if (_timer == null) {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time == 0) {
        timer.cancel();
      } else {
        setState(() {
          _time--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'touch panel',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Time: $_time',
              style: Theme.of(context).textTheme.headline3?.copyWith(color: Colors.white) ?? TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white) ?? TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return GestureDetector(
                  onTap: index == _randomCell ? _incrementCounter : null,
                  child: Container(
                    key: ValueKey('cell_$index'),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: index == _randomCell ? Colors.white : Colors.grey[850],
                    ),
                    child: Center(
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
