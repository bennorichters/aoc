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

  Set<Point> basins = {};
  for (Point p in heightmap.keys) {
    var height = heightmap[p]!;
    var ns = neighbours(p, maxX - 1, maxY - 1);
    var count = 0;
    for (var n in ns) {
      if (height < heightmap[n]!) count++;
    }
    if (count == ns.length) basins.add(p);
  }

  int sizeBasin(Point p) {
    int result = 0;
    Set<Point> visited = {};

    void sbRec(Set<Point> ns) {
      for (var n in ns) {
        if (heightmap[n]! != 9) {
          result++;
          var recNs = neighbours(n, maxX - 1, maxY - 1);
          recNs = recNs.difference(visited);
          visited.addAll(recNs);
          sbRec(recNs);
        }
      }
    }

    visited.add(p);
    sbRec({p});
    return result;
  }

  var result = [0, 0, 0];
  for (Point p in basins) {
    int size = sizeBasin(p);
    var i = result.indexWhere((e) => size > e);
    if (i > -1) result[i] = size;
  }

  print(result.reduce((p, v) => p * v));
}

Set<Point> neighbours(Point p, int maxX, int maxY) {
  Set<Point> result = {};
  if (p.x > 0) result.add(Point(p.x - 1, p.y));
  if (p.x < maxX) result.add(Point(p.x + 1, p.y));
  if (p.y > 0) result.add(Point(p.x, p.y - 1));
  if (p.y < maxY) result.add(Point(p.x, p.y + 1));

  return result;
}

