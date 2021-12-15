import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  final maxX = lines[0].length - 1;
  final maxY = lines.length - 1;

  var dangerMap = <Point, int>{};
  for (var y = 0; y <= maxY; y++) {
    for (var x = 0; x <= maxX; x++) {
      dangerMap[Point(x, y)] = int.parse(lines[y].substring(x, x + 1));
    }
  }

  Set<Point> neighbours(Point p) {
    var result = <Point>{};

    if (p.x > 0) result.add(Point(p.x - 1, p.y));
    if (p.x < maxX) result.add(Point(p.x + 1, p.y));
    if (p.y > 0) result.add(Point(p.x, p.y - 1));
    if (p.y < maxY) result.add(Point(p.x, p.y + 1));

    // if (p.x > 0 && p.y > 0) result.add(Point(p.x - 1, p.y - 1));
    // if (p.x < maxX && p.y > 0) result.add(Point(p.x + 1, p.y - 1));
    // if (p.x > 0 && p.y < maxY) result.add(Point(p.x - 1, p.y + 1));
    // if (p.x < maxX && p.y < maxY) result.add(Point(p.x + 1, p.y + 1));

    return result;
  }

  List<Point> findPath() {
    final end = Point(maxX, maxY);
    var result = <Point>[];
    int lowDanger = -1;

    var minDanger = <Point, int>{};

    List<Path> stack = [];
    Path start = Path([Point(0, 0)], 0);
    stack.add(start);

    while (stack.isNotEmpty) {
      // if (stack.length == 10) {
      //   stack.forEach(print);
      //   return [];
      // }
      var path = stack.removeAt(0);
      if (path.points.last == end) {
        if (lowDanger == -1 || path.danger < lowDanger) {
          lowDanger = path.danger;
          result = path.points;
        }
      } else if (path.points.last == Point(0, 0) ||
          path.danger <= minDanger[path.points.last]!) {
        var ns = neighbours(path.points.last);
        for (var n in ns) {
          if (!path.points.contains(n)) {
            var totalDanger = path.danger + dangerMap[n]!;
            if (!minDanger.containsKey(n) || totalDanger < minDanger[n]!) {
              minDanger[n] = totalDanger;
              var cPath = path.copy(n, totalDanger);
              stack.add(cPath);
            }
          }
        }
      }
    }

    // print(result);
    print(lowDanger);
    return result;
  }

  findPath();
  // print(sum);
}

class Path {
  final List<Point> points;
  final int danger;

  Path(this.points, this.danger);

  Path copy(Point tail, int cDanger) {
    var cPoints = List.of(points);
    cPoints.add(tail);
    return Path(cPoints, cDanger);
  }

  @override
  String toString() => '$danger $points';
}
