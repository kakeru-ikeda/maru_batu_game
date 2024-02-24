import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test002/game_model.dart';
import 'package:test002/top_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  /// 1ゲームの情報を保持するインスタンス
  Game game = Game();

  void _saveResult() async {
    DateTime now = DateTime.now();
    DateFormat dateFormater = DateFormat('yyyy-MM-dd hh:mm:ss');
    String date = dateFormater.format(now.toUtc());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> winners = prefs.getStringList('result') ?? [];
    winners.add(date + game.winner);
    prefs.setStringList('result', winners);
  }

  void _winCheck(int i, int j) {
    /// 勝利ユーザー判定用変数
    bool? winner;

    /// 既にマスが埋まっている場合またはゲームが終了している場合は処理を行わない
    if (game.imagePathList[i][j] != 'blank' || game.isStop) {
      return;
    }

    /// タップされたマスに〇か✕の画像を表示する
    game.imagePathList[i][j] = game.turn ? 'maru' : 'batu';

    /// 斜めの判定
    if ((game.imagePathList[0][0] == game.imagePathList[1][1] &&
            game.imagePathList[0][0] == game.imagePathList[2][2] &&
            game.imagePathList[0][0] != 'blank') ||
        (game.imagePathList[0][2] == game.imagePathList[1][1] &&
            game.imagePathList[0][2] == game.imagePathList[2][0] &&
            game.imagePathList[0][2] != 'blank')) {
      winner = game.turn;
    }

    /// 横と縦の判定
    for (int k = 0; k < 3; k++) {
      if ((game.imagePathList[k][0] == game.imagePathList[k][1] &&
              game.imagePathList[k][0] == game.imagePathList[k][2] &&
              game.imagePathList[k][0] != 'blank') ||
          (game.imagePathList[0][k] == game.imagePathList[1][k] &&
              game.imagePathList[0][k] == game.imagePathList[2][k] &&
              game.imagePathList[0][k] != 'blank')) {
        winner = game.turn;
      }
    }

    /// 勝利判定
    if (winner != null) {
      /// 勝利したプレイヤーを表示
      game.playerWin(turn: winner);
    } else {
      /// 引き分け判定
      for (int l = 0; l < game.imagePathList.length; l++) {
        if (game.imagePathList[l].contains('blank')) {
          /// blankマスがまだある場合はプレイヤーターンを切り替えて処理を終了
          game.toggleTurn({turn: turn});
          return;
        }
      }

      /// 全てのマスが埋まっている場合は引き分けとする
      game.draw();
    }

    /// ゲームが終了した場合は戦績を保存
    if (game.isStop) {
      _saveResult();
    }
  }

  void _reset() {
    /// インスタンスを再生成してゲームをリセット
    game = Game();
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
                            'assets/image/${game.imagePathList[i][j]}.png'),
                      ),
                    ),
                  },
                ],
              ),
            },
            Text(
              'player${game.turn ? 1 : 2}のターン',
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            Text(
              game.isStop ? game.winner : '',
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            Visibility(
              visible: game.isStop,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
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
