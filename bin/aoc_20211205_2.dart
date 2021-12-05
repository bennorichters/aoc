import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  Set<Point> hit = {};
  Set<Point> overlap = {};
  for (var line in lines) {
    var parts = line.split(' -> ');
    var start = pairToPoint(parts[0]);
    var end = pairToPoint(parts[1]);

    var steps = linePoints(start, end);
    for (var step in steps) {
      if (!hit.add(step)) overlap.add(step);
    }
  }

  print(overlap.length);
}

Point pairToPoint(String pair) {
  var parts = pair.split(',');
  return Point(int.parse(parts[0]), int.parse(parts[1]));
}

List<Point> linePoints(Point start, Point end) {
  int diffX = (end.x - start.x).floor().sign;
  int diffY = (end.y - start.y).floor().sign;

  List<Point> result = [];
  Point step = Point(start.x, start.y);
  while (step != end) {
    result.add(step);
    step = Point(step.x + diffX, step.y + diffY);
  }

  result.add(end);
  return result;
}
