import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

// Only second puzzle

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var blockSize = lines[0].length;
  var dangerMap = parseDangerMap(lines, blockSize);
  var endOfGrid = blockSize * 5 - 1;

  Set<Point> neighbours(Point p) {
    var result = <Point>{};

    if (p.x > 0) result.add(Point(p.x - 1, p.y));
    if (p.x < endOfGrid) result.add(Point(p.x + 1, p.y));
    if (p.y > 0) result.add(Point(p.x, p.y - 1));
    if (p.y < endOfGrid) result.add(Point(p.x, p.y + 1));

    return result;
  }

  int findPath() {
    var start = Point(0, 0);
    var minDanger = <Point, int>{start: 0};
    var stack = PriorityQueue<Node>()..add(Node(start, 0));

    while (stack.isNotEmpty) {
      var node = stack.removeFirst();
      var ns = neighbours(node.point);
      for (var n in ns) {
        var totalDanger = minDanger[node.point]! + dangerMap[n]!;
        if (!minDanger.containsKey(n) || totalDanger < minDanger[n]!) {
          minDanger[n] = totalDanger;
          stack.add(Node(n, (totalDanger + 2 * endOfGrid - n.x - n.y).floor()));
        }
      }
    }

    return minDanger[Point(endOfGrid, endOfGrid)]!;
  }

  print(findPath());
}

class Node implements Comparable {
  final Point point;
  final int estimate;

  Node(this.point, this.estimate);

  @override
  int compareTo(other) => (estimate - other.estimate).floor();
}

Map<Point, int> parseDangerMap(List<String> lines, int blockSize) {
  var dangerMap = <Point, int>{};
  for (var y = 0; y < blockSize; y++) {
    for (var x = 0; x < blockSize; x++) {
      dangerMap[Point(x, y)] = int.parse(lines[y].substring(x, x + 1));
    }
  }

  for (int blockY = 0; blockY < 5; blockY++) {
    for (int blockX = 0; blockX < 5; blockX++) {
      if (blockY > 0 || blockX > 0) {
        for (var y = 0; y < blockSize; y++) {
          for (var x = 0; x < blockSize; x++) {
            var px = blockSize * blockX + x;
            var py = blockSize * blockY + y;
            var refX = blockSize * (blockX - (blockX > 0 ? 1 : 0)) + x;
            var refY = blockSize * (blockY - (blockX > 0 ? 0 : 1)) + y;
            var refValue = dangerMap[Point(refX, refY)]!;
            dangerMap[Point(px, py)] = refValue == 9 ? 1 : refValue + 1;
          }
        }
      }
    }
  }

  return dangerMap;
}
