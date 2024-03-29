import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'touch panel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'touch panel'),
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
  bool _isVisible = true;
  Timer? _timer;
  bool _timerStarted = false; // 追加した変数

  void _incrementCounter() {
    if (_time > 0) {
      if (!_timerStarted) { // タイマーがまだ開始されていない場合
        _startTimer(); // タイマーを開始
        _timerStarted = true; // タイマーが開始されたことを記録
      }
      setState(() {
        _counter++;
        do {
          _randomCell = Random().nextInt(9);
        } while (_randomCell == _previousCell);
        _previousCell = _randomCell;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time == 0) {
        timer.cancel();
        _startBlinking();
      } else {
        setState(() {
          _time--;
        });
      }
    });
  }

  void _startBlinking() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_time > 0) {
        timer.cancel();
      } else {
        setState(() {
          _isVisible = !_isVisible; // 可視性を反転させる
        });
      }
    });
  }


  void _resetGame() {
    setState(() {
      _time = 30;
      _counter = 0;
      _randomCell = Random().nextInt(9);
      _previousCell = -1;
      _timerStarted = false; // ゲームをリセットするときにタイマーの状態もリセット
      _isVisible = true;
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
            padding: const EdgeInsets.all(10.0),
            child: _time > 0 ? Text(
              'Time: $_time',
              style: Theme.of(context).textTheme.headline3?.copyWith(color: Colors.white) ?? TextStyle(color: Colors.white, fontSize: 30),
            ) : ElevatedButton(
              onPressed: _resetGame,
              child: Text('Replay'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[850], // 背景色を濃いグレー[850]に
                onPrimary: Colors.white, // 文字色をホワイトに
                side: BorderSide(color: Colors.white, width: 2.0), // 枠線をホワイトに
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white, fontSize: 50) ?? TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return GestureDetector(
                  onTap: index == _randomCell ? _incrementCounter : null,
                  child: Container(
                    key: ValueKey('cell_$index'),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: _time > 0 && index == _randomCell ? Colors.white : Colors.grey[850],
                    ),
                    child: Center(),
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
