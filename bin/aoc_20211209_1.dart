import 'dart:io';
import 'dart:math';

void main() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var maxX = lines[0].length;
  var maxY = lines.length;
  var heightmap = <Point, num>{};
  for (int x = 0; x < maxX; x++) {
    for (int y = 0; y < maxY; y++) {
      heightmap[Point(x, y)] = int.parse((lines[y].split(''))[x]);
    }
  }

  var result = 0;
  for (Point p in heightmap.keys) {
    var height = heightmap[p]!;
    var ns = neighbours(p, maxX - 1, maxY - 1);
    var count = 0;
    for (var n in ns) {
      if (height < heightmap[n]!) count++;
    }
    if (count == ns.length) {
      result += (height + 1).floor();
      print('$p, $height, $result');
    }
  }
  print(result);
}

Set<Point> neighbours(Point p, int maxX, int maxY) {
  Set<Point> result = {};
  if (p.x > 0) result.add(Point(p.x - 1, p.y));
  if (p.x < maxX) result.add(Point(p.x + 1, p.y));
  if (p.y > 0) result.add(Point(p.x, p.y - 1));
  if (p.y < maxY) result.add(Point(p.x, p.y + 1));

  return result;
}
