import 'dart:math';

void main() {
  var result = 0;
  for (var fish in fishes) {
    result += offspring(Point(fish, 256));
  }

  print(result);
}

Map<Point, int> cache = {};

int offspring(Point data) {
  if (cache.containsKey(data)) return cache[data]!;
  if (data.y == 0) return 1;

  if (data.x == 0) {
    var p0 = Point(6, data.y - 1);
    var r0 = offspring(p0);
    cache[p0] = r0;

    var p1 = Point(8, data.y - 1);
    var r1 = offspring(p1);
    cache[p1] = r1;

    return r0 + r1;
  } else {
    var p = Point(data.x - 1, data.y - 1);
    var r = offspring(p);
    cache[p] = r;

    return r;
  }
}

// var fishes = [3, 4, 3, 1, 2];
var fishes = [1,3,4,1,5,2,1,1,1,1,5,1,5,1,1,1,1,3,1,1,1,1,1,1,1,2,1,5,1,1,1,1,1,4,4,1,1,4,1,1,2,3,1,5,1,4,1,2,4,1,1,1,1,1,1,1,1,2,5,3,3,5,1,1,1,1,4,1,1,3,1,1,1,2,3,4,1,1,5,1,1,1,1,1,2,1,3,1,3,1,2,5,1,1,1,1,5,1,5,5,1,1,1,1,3,4,4,4,1,5,1,1,4,4,1,1,1,1,3,1,1,1,1,1,1,3,2,1,4,1,1,4,1,5,5,1,2,2,1,5,4,2,1,1,5,1,5,1,3,1,1,1,1,1,4,1,2,1,1,5,1,1,4,1,4,5,3,5,5,1,2,1,1,1,1,1,3,5,1,2,1,2,1,3,1,1,1,1,1,4,5,4,1,3,3,1,1,1,1,1,1,1,1,1,5,1,1,1,5,1,1,4,1,5,2,4,1,1,1,2,1,1,4,4,1,2,1,1,1,1,5,3,1,1,1,1,4,1,4,1,1,1,1,1,1,3,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,5,1,2,1,1,1,1,1,1,1,1,1];
