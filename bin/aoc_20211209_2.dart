import 'dart:io';
import 'dart:math';

void main() {
  // final lines = File('./tin').readAsLinesSync();
  final lines = File('./in').readAsLinesSync();

  final maxX = lines[0].length - 1;
  final maxY = lines.length - 1;

  final heightmap = (() {
    var result = <Point, num>{};
    for (var x = 0; x <= maxX; x++) {
      for (var y = 0; y <= maxY; y++) {
        result[Point(x, y)] = int.parse((lines[y].split(''))[x]);
      }
    }
    return result;
  })();

  Set<Point> neighbours(Point p) {
    var result = <Point>{};
    if (p.x > 0) result.add(Point(p.x - 1, p.y));
    if (p.x < maxX) result.add(Point(p.x + 1, p.y));
    if (p.y > 0) result.add(Point(p.x, p.y - 1));
    if (p.y < maxY) result.add(Point(p.x, p.y + 1));
    return result;
  }

  final basins = (() {
    var result = <Point>{};
    for (var p in heightmap.keys) {
      var height = heightmap[p]!;
      var ns = neighbours(p);
      var count = ns.where((e) => height < heightmap[e]!).length;
      if (count == ns.length) result.add(p);
    }
    return result;
  })();

  int sizeBasin(Point p) {
    var result = 0;
    var visited = {p};

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

    sbRec({p});
    return result;
  }

  var result = [0, 0, 0];
  for (var p in basins) {
    var size = sizeBasin(p);
    var i = result.indexWhere((e) => size > e);
    if (i > -1) result[i] = size;
  }
  print(result.reduce((p, v) => p * v));
}
