import 'dart:io';
import 'dart:math';

void main() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var alg = '';
  var i = 0;
  for (; lines[i].isNotEmpty; i++) {
    alg += lines[i];
  }

  i++;
  var pic = <Point, bool>{};
  for (var y = 0; (y + i) < lines.length; y++) {
    var line = lines[y + i].split('');
    for (var x = 0; x < line.length; x++) {
      pic[Point(x, y)] = line[x] == '#';
    }
  }

  int picPointNr(Point p) {
    var bin = '';
    for (var y = p.y - 1; y <= p.y + 1; y++) {
      for (var x = p.x - 1; x <= p.x + 1; x++) {
        var test = Point(x, y);
        bin += pic.containsKey(test) && pic[test]! ? '1' : '0';
      }
    }

    return int.parse(bin, radix: 2);
  }

  bool isLight(Point p) {
    var nr = picPointNr(p);
    return alg.substring(nr, nr + 1) == '#';
  }

  var minX = -150;
  var minY = -150; 
  var maxX = lines[i].length + 150;
  var maxY = lines.length - i + 150;

  for (var i = 0; i < 50; i++) {
    print(i);
    var rPic = <Point, bool>{};
    for (var y = minY; y <= maxY; y++) {
      for (var x = minX; x <= maxX; x++) {
        var key = Point(x, y);
        rPic[key] = isLight(key);
      }
    }
    pic = rPic;
    minX+=2;
    minY+=2;
    maxX-=2;
    maxY-=2;
  }

  print(pic.values.where((e) => e).length);
}


