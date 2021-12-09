import 'dart:io';
import 'dart:math';

void main() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var maxX = lines[0].length - 1;
  var maxY = lines.length - 1;

  var heightmap = (() {
    var result = <Point, num>{};
    for (var x = 0; x <= maxX; x++) {
      for (var y = 0; y <= maxY; y++) {
        result[Point(x, y)] = int.parse((lines[y].split(''))[x]);
      }
    }
    return result;
  })();

  Set<Point> neighbours(Point p) {
    Set<Point> result = {};
    if (p.x > 0) result.add(Point(p.x - 1, p.y));
    if (p.x < maxX) result.add(Point(p.x + 1, p.y));
    if (p.y > 0) result.add(Point(p.x, p.y - 1));
    if (p.y < maxY) result.add(Point(p.x, p.y + 1));

    return result;
  }

  Set<Point> basins = (() {
    var result = <Point>{};
    for (Point p in heightmap.keys) {
      var height = heightmap[p]!;
      var ns = neighbours(p);
      var count = ns.where((e) => height < heightmap[e]!).length;
      if (count == ns.length) result.add(p);
    }
    return result;
  })();

  int sizeBasin(Point p) {
    var result = 0;
    Set<Point> visited = {};

    void sbRec(Set<Point> ns) {
      for (var n in ns) {
        if (heightmap[n]! != 9) {
          result++;
          var recNs = neighbours(n);
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
    var size = sizeBasin(p);
    var i = result.indexWhere((e) => size > e);
    if (i > -1) result[i] = size;
  }

  print(result.reduce((p, v) => p * v));
}
