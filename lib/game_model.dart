class Game {
  late bool turn;
  late bool isStop;
  late String winner;
  List<List<String>> imagePathList = [
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank']
  ];

  Game({
    required this.turn,
    required this.isStop,
    required this.winner,
  });

  void playerWin({required bool turn}) {
    winner = 'player${turn ? 1 : 2}の勝利！';
    isStop = true;
  }

  void draw() {
    winner = '引き分け';
    isStop = true;
  }
}
