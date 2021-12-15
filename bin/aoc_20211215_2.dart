import 'dart:io';
import 'dart:math';

// Only second puzzle

void main(List<String> arguments) {
  var lines = File('./tin').readAsLinesSync();
  // var lines = File('./in').readAsLinesSync();

  var blockWidth = lines[0].length;
  var blockHeight = lines.length;

  var dangerMap = parseDangerMap(lines, blockWidth, blockHeight);

  var maxX = blockWidth * 5 - 1;
  var maxY = blockHeight * 5 - 1;

  Set<Point> neighbours(Point p) {
    var result = <Point>{};

    if (p.x > 0) result.add(Point(p.x - 1, p.y));
    if (p.x < maxX) result.add(Point(p.x + 1, p.y));
    if (p.y > 0) result.add(Point(p.x, p.y - 1));
    if (p.y < maxY) result.add(Point(p.x, p.y + 1));

    return result;
  }

  int findPath() {
    final end = Point(maxX, maxY);
    int lowDanger = -1;

    var start = Point(0, 0);
    var minDanger = <Point, int>{start: 1};
    var stack = [
      Path([start], 0)
    ];

    while (stack.isNotEmpty) {
      var path = stack.removeAt(0);
      if (path.last == end && (lowDanger == -1 || path.danger < lowDanger)) {
        lowDanger = path.danger;
      } else if (path.danger <= minDanger[path.points.last]!) {
        var ns = neighbours(path.last).where((e) => !path.contains(e));
        for (var n in ns) {
          var totalDanger = path.danger + dangerMap[n]!;
          if (!minDanger.containsKey(n) || totalDanger < minDanger[n]!) {
            minDanger[n] = totalDanger;
            stack.add(path.copy(n, totalDanger));
          }
        }
      }
    }

    return lowDanger;
  }

  print(findPath());
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

  Point get last => points.last;

  bool contains(Point point) => points.contains(point);

  @override
  String toString() => '$danger $points';
}

Map<Point, int> parseDangerMap(
  List<String> lines,
  int blockWidth,
  int blockHeight,
) {
  var dangerMap = <Point, int>{};
  for (var y = 0; y < blockHeight; y++) {
    for (var x = 0; x < blockWidth; x++) {
      dangerMap[Point(x, y)] = int.parse(lines[y].substring(x, x + 1));
    }
  }

  for (int blockY = 0; blockY < 5; blockY++) {
    for (int blockX = 0; blockX < 5; blockX++) {
      if (blockY > 0 || blockX > 0) {
        for (var y = 0; y < blockHeight; y++) {
          for (var x = 0; x < blockWidth; x++) {
            var px = blockWidth * blockX + x;
            var py = blockHeight * blockY + y;
            var refX = blockWidth * (blockX - (blockX > 0 ? 1 : 0)) + x;
            var refY = blockHeight * (blockY - (blockX > 0 ? 0 : 1)) + y;
            var refValue = dangerMap[Point(refX, refY)]!;
            dangerMap[Point(px, py)] = refValue == 9 ? 1 : refValue + 1;
          }
        }
      }
    }
  }

  return dangerMap;
}
