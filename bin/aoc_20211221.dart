// const p1Start = 4;
// const p2Start = 8;

const p1Start = 9;
const p2Start = 6;
// 1098000

void main(List<String> arguments) {
  var die = Die();
  var p1 = Player(p1Start);
  var p2 = Player(p2Start);

  while (true) {
    // for (var i = 0; i < 36; i++) {
    if (play(p1, die)) break;
    if (play(p2, die)) break;
  }

  print(p1);
  print(p2);
  print(die);
  print('');

  print(p1.score * die.count);
  print(p2.score * die.count);
}

bool play(Player p, Die die) {
  for (var i = 0; i < 3; i++) {
    p.position += (die.next() % 10);
    if (p.position > 10) p.position %= 10;
  }
  p.score += p.position;

  return (p.score >= 1000);
}

class Player {
  int position;
  int score = 0;
  Player(this.position);

  @override
  String toString() => 'Player - position:$position score:$score';
}

class Die {
  int value = 0;
  int count = 0;

  int next() {
    value++;
    if (value == 101) value = 1;
    count++;

    return value;
  }

  @override
  String toString() => 'Die - value:$value count:$count';
}
