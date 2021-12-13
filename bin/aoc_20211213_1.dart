import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  var lines = File('./tin').readAsLinesSync();
  // var lines = File('./in').readAsLinesSync();

  var dots = <Point>{};
  for (var line in lines) {
    if (line.trim().isEmpty) break;
    var parts = line.split(',');
    var x = int.parse(parts[0]);
    var y = int.parse(parts[1]);
    dots.add(Point(x, y));
  }

  var parts = lines[dots.length + 1].split('fold along ')[1].split('=');
  var isXFold = parts[0] == 'x';
  var foldNr = int.parse(parts[1]);

  var result = <Point>{};
  for (var d in dots) {
    if (isXFold && d.x > foldNr) {
      result.add(Point(2 * foldNr - d.x, d.y));
    } else if (!isXFold && d.y > foldNr) {
      result.add(Point(d.x, 2 * foldNr - d.y));
    } else {
      result.add(d);
    }
  }

  print(result.length);
}

