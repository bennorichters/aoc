import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  Set<Coordinate> hit = {};
  Set<Coordinate> double = {};
  for (var line in lines) {
    var parts = line.split(' -> ');
    var start = pairToCoord(parts[0]);
    var end = pairToCoord(parts[1]);

    var steps = lineCoords(start, end);
    for (var step in steps) {
      if (!hit.add(step)) double.add(step);
    }
  }

  print(double.length);
}

class Coordinate {
  final int x;
  final int y;

  Coordinate(this.x, this.y);

  @override
  String toString() => '[$x, $y]';

  @override
  bool operator ==(other) =>
      (other is Coordinate) && x == other.x && y == other.y;

  @override
  int get hashCode => x + 31 * y;
}

Coordinate pairToCoord(String pair) {
  var parts = pair.split(',');
  return Coordinate(int.parse(parts[0]), int.parse(parts[1]));
}

List<Coordinate> lineCoords(Coordinate start, Coordinate end) {
  int diffX = (end.x - start.x).sign;
  int diffY = (end.y - start.y).sign;

  List<Coordinate> result = [];
  Coordinate step = Coordinate(start.x, start.y);
  while (step != end) {
    result.add(step);
    step = Coordinate(step.x + diffX, step.y + diffY);
  }

  result.add(end);
  return result;
}
