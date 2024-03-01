class Game {
  bool turn = true;
  bool isStop = false;
  String winner = '';
  List<List<String>> imagePathList = [
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank'],
    ['blank', 'blank', 'blank']
  ];

  void setImage(int i, int j) {
    imagePathList[i][j] = turn ? 'maru' : 'batu';
  }

  bool? judgeWinner() {
    bool? winner;

    /// 斜めの判定
    if ((imagePathList[0][0] == imagePathList[1][1] &&
            imagePathList[0][0] == imagePathList[2][2] &&
            imagePathList[0][0] != 'blank') ||
        (imagePathList[0][2] == imagePathList[1][1] &&
            imagePathList[0][2] == imagePathList[2][0] &&
            imagePathList[0][2] != 'blank')) {
      winner = turn;
    }

    /// 横と縦の判定
    for (int k = 0; k < 3; k++) {
      if ((imagePathList[k][0] == imagePathList[k][1] &&
              imagePathList[k][0] == imagePathList[k][2] &&
              imagePathList[k][0] != 'blank') ||
          (imagePathList[0][k] == imagePathList[1][k] &&
              imagePathList[0][k] == imagePathList[2][k] &&
              imagePathList[0][k] != 'blank')) {
        winner = turn;
      }
    }
    return winner;
  }

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
