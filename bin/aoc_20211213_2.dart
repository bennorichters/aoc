import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var dots = <Point>{};
  for (var line in lines) {
    if (line.trim().isEmpty) break;
    var parts = line.split(',');
    var x = int.parse(parts[0]);
    var y = int.parse(parts[1]);
    dots.add(Point(x, y));
  }

  var result = Set.of(dots);
  for (var lineIndex = dots.length + 1; lineIndex < lines.length; lineIndex++) {
    var parts = lines[lineIndex].split('fold along ')[1].split('=');
    var isXFold = parts[0] == 'x';
    var foldNr = int.parse(parts[1]);

    var folded = <Point>{};
    for (var d in result) {
      if (isXFold && d.x > foldNr) {
        folded.add(Point(2 * foldNr - d.x, d.y));
      } else if (!isXFold && d.y > foldNr) {
        folded.add(Point(d.x, 2 * foldNr - d.y));
      } else {
        folded.add(d);
      }
    }

    result = Set.of(folded);
  }

  var maxX = result.fold(0, (num prev, e) => max<num>(prev, e.x));
  var maxY = result.fold(0, (num prev, e) => max<num>(prev, e.y));

  for (var y = 0; y <= maxY; y++) {
    var line = '';
    for (var x = 0; x <= maxX; x++) {
      line += result.contains(Point(x, y)) ? '#' : '.';
    }
    print(line);
  }
}
