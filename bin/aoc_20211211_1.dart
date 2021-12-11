import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  final maxX = 9;
  final maxY = 9;

  final octos = (() {
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

    if (p.x > 0 && p.y > 0) result.add(Point(p.x - 1, p.y - 1));
    if (p.x < maxX && p.y > 0) result.add(Point(p.x + 1, p.y - 1));
    if (p.x > 0 && p.y < maxY) result.add(Point(p.x - 1, p.y + 1));
    if (p.x < maxX && p.y < maxY) result.add(Point(p.x + 1, p.y + 1));

    return result;
  }

  int flash() {
    var toProcess = List.of(octos.keys);
    var flashed = <Point>{};

    while (toProcess.isNotEmpty) {
      var extra = <Point>[];
      for (Point p in toProcess) {
        if (!flashed.contains(p)) {
          if (octos[p] == 9) {
            flashed.add(p);
            octos[p] = 0;
            var ns = neighbours(p);
            extra.addAll(ns);
          } else {
            octos[p] = octos[p]! + 1;
          }
        }
      }

      extra.removeWhere((e) => flashed.contains(e));
      toProcess = List.from(extra);
    }

    return flashed.length;
  }

  var result = 0;
  for (int i = 0; i < 100; i++) {
    result += flash();
  }
  print(result);
}
