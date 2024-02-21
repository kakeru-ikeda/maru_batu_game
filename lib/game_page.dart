import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test002/top_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _turn = true;
  bool _gameStop = false;
  String _winner = '';

  List<List<String>> imagePathList = [
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank'],
  ];
  void _playerWin({required bool turn}) {
    _winner = 'player${turn ? 1 : 2}の勝利！';
    _gameStop = true;
    _saveResult();
  }

  void _winCheck(int i, int j) {
    if (imagePathList[i][j] == 'blank' && _gameStop == false) {
      imagePathList[i][j] = _turn ? 'maru' : 'batu';
      if (imagePathList[0][0] == imagePathList[1][1] &&
          imagePathList[0][0] == imagePathList[2][2] &&
          imagePathList[0][0] != 'blank') {
        _playerWin(turn: _turn);
        return;
      } else if (imagePathList[0][2] == imagePathList[1][1] &&
          imagePathList[0][2] == imagePathList[2][0] &&
          imagePathList[0][2] != 'blank') {
        _playerWin(turn: _turn);
        return;
      }

      for (int k = 0; k < 3; k++) {
        if (imagePathList[k][0] == imagePathList[k][1] &&
            imagePathList[k][0] == imagePathList[k][2] &&
            imagePathList[k][0] != 'blank') {
          _playerWin(turn: _turn);
          return;
        } else if (imagePathList[0][k] == imagePathList[1][k] &&
            imagePathList[0][k] == imagePathList[2][k] &&
            imagePathList[0][k] != 'blank') {
          _playerWin(turn: _turn);
          return;
        }
      }
      for (int l = 0; l < imagePathList.length; l++) {
        if (imagePathList[l].contains('blank')) {
          _turn = !_turn;
          return;
        }
      }
      _gameStop = true;
      _winner = '引き分け！';
      _saveResult();
    }
  }

  void _saveResult() async {
    DateTime now = DateTime.now();
    DateFormat dateFormater = DateFormat('yyyy-MM-dd hh:mm:ss');
    String date = dateFormater.format(now.toUtc());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> winners = prefs.getStringList('result') ?? [];
    winners.add(date + _winner);
    prefs.setStringList('result', winners);
  }

  void _reset() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        imagePathList[i][j] = 'blank';
        _turn = true;
        _gameStop = false;
        _winner = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('〇✕ゲーム'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < 3; i++) ...{
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int j = 0; j < 3; j++) ...{
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _winCheck(i, j);
                          });
                        },
                        child: Image.asset(
                            'assets/image/${imagePathList[i][j]}.png'),
                      ),
                    ),
                  },
                ],
              ),
            },
            Text(
              'player${_turn ? 1 : 2}のターン',
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            Text(
              _gameStop ? _winner : '',
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            Visibility(
              visible: _gameStop,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TopPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.blue,
                ),
                child: const Text('トップに戻る'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _reset();
          });
        },
        tooltip: 'リセット',
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}
