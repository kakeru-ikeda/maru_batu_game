import 'package:flutter/material.dart';
import 'package:test002/main.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _turn = true;
  bool _gameStop = false;
  String _winner = '';

  // ignore: prefer_final_fields
  List<List<String>> _imagePathList = [
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank'],
  ];
  void _playerWin(bool turn) {
    _winner = 'player${turn ? 1 : 2}の勝利！';
    _gameStop = true;
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
            Column(
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
                                if (_imagePathList[i][j] == 'blank' &&
                                    _gameStop == false) {
                                  _imagePathList[i][j] =
                                      _turn ? 'maru' : 'batu';
                                  if (_imagePathList[0][0] ==
                                          _imagePathList[1][1] &&
                                      _imagePathList[0][0] ==
                                          _imagePathList[2][2] &&
                                      _imagePathList[0][0] != 'blank') {
                                    _playerWin(_turn);
                                    return;
                                  } else if (_imagePathList[0][2] ==
                                          _imagePathList[1][1] &&
                                      _imagePathList[0][2] ==
                                          _imagePathList[2][0] &&
                                      _imagePathList[0][2] != 'blank') {
                                    _playerWin(_turn);
                                    return;
                                  }

                                  for (int k = 0; k < 3; k++) {
                                    if (_imagePathList[k][0] ==
                                            _imagePathList[k][1] &&
                                        _imagePathList[k][0] ==
                                            _imagePathList[k][2] &&
                                        _imagePathList[k][0] != 'blank') {
                                      _playerWin(_turn);
                                      return;
                                    } else if (_imagePathList[0][k] ==
                                            _imagePathList[1][k] &&
                                        _imagePathList[0][k] ==
                                            _imagePathList[2][k] &&
                                        _imagePathList[0][k] != 'blank') {
                                      _playerWin(_turn);
                                      return;
                                    }
                                  }
                                  for (int l = 0;
                                      l < _imagePathList.length;
                                      l++) {
                                    if (_imagePathList[l].contains('blank')) {
                                      _turn = !_turn;
                                      return;
                                    }
                                  }
                                  _gameStop = true;
                                  _winner = '引き分け！';
                                }
                              });
                            },
                            child: Image.asset(
                                'assets/image/${_imagePathList[i][j]}.png'),
                          ),
                        ),
                      },
                    ],
                  ),
                },
              ],
            ),
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
                    MaterialPageRoute(builder: (context) => const MyApp()),
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
            for (int i = 0; i < 3; i++) {
              for (int j = 0; j < 3; j++) {
                _imagePathList[i][j] = 'blank';
                _turn = true;
                _gameStop = false;
                _winner = '';
              }
            }
          });
        },
        tooltip: 'リセット',
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}
