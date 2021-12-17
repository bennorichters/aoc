import 'dart:math';

// target area: x=20..30, y=-10..-5
// const minTx = 20;
// const maxTx = 30;
// const minTy = -10;
// const maxTy = -5;

// target area: x=240..292, y=-90..-57
const minTx = 240;
const maxTx = 292;
const minTy = -90;
const maxTy = -57;

void main(List<String> arguments) {
  int maxY = -minTy - 1;
  int count = 0;
  for (var vx = 0; vx <= maxTx; vx++) {
    var vy = minTy;
    var ongoing = true;
    while (ongoing) {
      var t = testVelocities(vx, vy);
      if (t.hit) {
        maxY = max(maxY, t.maxY);
        count++;
      }

      ongoing = t.x <= maxTx && (t.vx > 0 || (t.x >= minTx && t.vy >= minTy));
      vy++;
    }
  }

  print(maxY);
  print(count);
}

TestResult testVelocities(int vx, int vy) {
  int x = 0;
  int y = 0;

  int maxY = 0;
  while (x <= maxTx && y >= minTy && (vx > 0 || (x >= minTx && x <= maxTx))) {
    if (x >= minTx && y <= maxTy) return TestResult(true, maxY, x, y, vx, vy);
    x += vx;
    y += vy;

    maxY = max(maxY, y);

    vx -= vx.sign;
    vy--;
  }

  return TestResult(false, maxY, x, y, vx, vy);
}

class TestResult {
  final bool hit;
  final int maxY;
  final int x;
  final int y;
  final int vx;
  final int vy;
  TestResult(this.hit, this.maxY, this.x, this.y, this.vx, this.vy);

  @override
  String toString() =>
      'Trajectory: hit=$hit, maxY=$maxY, x=$x, y=$y, vx=$vx, vy=$vy';
}
