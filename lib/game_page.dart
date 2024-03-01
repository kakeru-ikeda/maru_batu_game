import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test002/game_model.dart';
import 'package:test002/shared_preferences_service.dart';
import 'package:test002/top_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  /// 1ゲームの情報を保持するインスタンス
  late Game game;

  /// SharedPreferencesのインスタンス
  final SharedPreferencesService prefs = SharedPreferencesService.instance;

  @override
  void initState() {
    super.initState();
    game = Game();
  }

  void _reset() {
    /// インスタンスを再生成してゲームをリセット
    game = Game();
  }

  void _saveResult() async {
    DateTime now = DateTime.now();
    DateFormat dateFormater = DateFormat('yyyy-MM-dd hh:mm:ss');
    String date = dateFormater.format(now.toUtc());

    List<String> winners = await prefs.getStringList('result') ?? [];
    winners.add(date + game.winner);
    await prefs.setStringList('result', winners);
  }

  void _winCheck(int i, int j) {
    /// 既にマスが埋まっている場合またはゲームが終了している場合は処理を行わない
    if (game.imagePathList[i][j] != 'blank' || game.isStop) {
      return;
    }

    /// タップされたマスに〇か✕の画像を表示する
    game.setImage(i, j);

    /// 判定処理
    bool? winner = game.judgeWinner();

    /// 勝利判定
    if (winner != null) {
      /// 勝利したプレイヤーを表示
      game.playerWin(turn: winner);
    } else {
      /// 引き分け判定
      for (int l = 0; l < game.imagePathList.length; l++) {
        if (game.imagePathList[l].contains('blank')) {
          /// blankマスがまだある場合はプレイヤーターンを切り替えて処理を終了
          game.toggleTurn();
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
