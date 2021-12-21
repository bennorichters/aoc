// const p1Start = 4;
// const p2Start = 8;

const p1Start = 9;
const p2Start = 6;

// 01. 003 - 3 - 1
// 02. 012 - 4 - 3
// 03. 102 - 5 - 3
// 04. 021 - 5 - 3
// 05. 111 - 6 - 6
// 06. 201 - 7 - 3
// 07. 030 - 6 - 1
// 08. 120 - 7 - 3
// 09. 210 - 8 - 3
// 10. 300 - 9 - 1

const dieDist = {
  3: 1,
  4: 3,
  5: 6,
  6: 7,
  7: 6,
  8: 3,
  9: 1,
};

void main() {
  var universes = {
    const GameState(
      PlayerState(p1Start, 0),
      PlayerState(p2Start, 0),
      true,
    ): 1,
  };

  GameState next() =>
      (universes.keys.where((element) => !element.finished).toList()
            ..sort(
              (a, b) => a.ps1.score + a.ps2.score - b.ps1.score - b.ps2.score,
            ))
          .first;

  while (universes.keys.any((element) => !element.finished)) {
    var gs = next();
    var count = universes[gs]!;
    for (var die in dieDist.keys) {
      var rgs = gs.move(die);
      universes.putIfAbsent(rgs, () => 0);
      universes[rgs] = universes[rgs]! + count * dieDist[die]!;
    }
    universes.remove(gs);
  }

  var winsPlayer1 = universes.keys
      .where((e) => e.ps1.finished)
      .fold(0, (int p, GameState gs) => p + universes[gs]!);
  print(winsPlayer1);

  var winsPlayer2 = universes.keys
      .where((e) => e.ps2.finished)
      .fold(0, (int p, GameState gs) => p + universes[gs]!);
  print(winsPlayer2);
}

class GameState {
  final PlayerState ps1;
  final PlayerState ps2;
  final bool player1Move;
  const GameState(this.ps1, this.ps2, this.player1Move);

  bool get finished => ps1.finished || ps2.finished;

  GameState move(int number) => GameState(
        player1Move ? ps1.move(number) : ps1,
        player1Move ? ps2 : ps2.move(number),
        !player1Move,
      );

  @override
  int get hashCode =>
      player1Move.hashCode + 3 * ps1.hashCode + 13 * ps2.hashCode;

  @override
  bool operator ==(other) =>
      (other is GameState) &&
      player1Move == other.player1Move &&
      ps1 == other.ps1 &&
      ps2 == other.ps2;

  @override
  String toString() =>
      'GameState[ps1:$ps1, ps2:$ps2, toMove:${player1Move ? 1 : 2}]';
}

class PlayerState {
  final int position;
  final int score;
  const PlayerState(this.position, this.score);

  PlayerState move(int number) {
    var rPosition = position + number;
    if (rPosition > 10) rPosition %= 10;
    var rScore = score + rPosition;
    return PlayerState(rPosition, rScore);
  }

  bool get finished => score >= 21;

  @override
  int get hashCode => 7 * position + 31 * score;

  @override
  bool operator ==(other) =>
      (other is PlayerState) &&
      position == other.position &&
      score == other.score;

  @override
  String toString() => 'PlayerState[position:$position, score:$score]';
}
