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
  int maxY = 0;
  int count = 0;
  for (var vx = 0; vx <= maxTx; vx++) {
    var vy = minTy;
    var p = Probe(false, 0, 0, 0, vx, vy);
    while (p.x <= maxTx && (p.vx > 0 || (p.x >= minTx && p.vy >= minTy))) {
      p = testVelocities(vx, vy);
      if (p.hit) {
        maxY = max(maxY, p.maxY);
        count++;
      }
      
      vy++;
    }
  }

  print(maxY);
  print(count);
}

Probe testVelocities(int vx, int vy) {
  int x = 0;
  int y = 0;

  int maxY = 0;
  while (x <= maxTx && y >= minTy && (vx > 0 || x >= minTx)) {
    if (x >= minTx && y <= maxTy) return Probe(true, maxY, x, y, vx, vy);
    x += vx;
    y += vy;

    maxY = max(maxY, y);

    vx -= vx.sign;
    vy--;
  }

  return Probe(false, maxY, x, y, vx, vy);
}

class Probe {
  final bool hit;
  final int maxY;
  final int x;
  final int y;
  final int vx;
  final int vy;
  Probe(this.hit, this.maxY, this.x, this.y, this.vx, this.vy);

  @override
  String toString() =>
      'Trajectory: hit=$hit, maxY=$maxY, x=$x, y=$y, vx=$vx, vy=$vy';
}
