class Game {
  bool turn = true;
  bool isStop = false;
  String winner = '';
  List<List<String>> imagePathList = [
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank']
  ];

  void toggleTurn() {
    turn = !turn;
  }

  void playerWin({required bool turn}) {
    winner = 'player${turn ? 1 : 2}の勝利！';
    isStop = true;
  }

  void draw() {
    winner = '引き分け';
    isStop = true;
  }
}
