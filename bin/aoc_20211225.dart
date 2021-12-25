import 'dart:io';
import 'dart:math';

void main() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var maxY = lines.length - 1;
  var maxX = lines[0].length - 1;
  var easters = <Point>{};
  var southers = <Point>{};
  for (var y = 0; y <= maxY; y++) {
    for (var x = 0; x <= maxX; x++) {
      var char = lines[y].substring(x, x + 1);
      var point = Point(x, y);
      if (char == '>') {
        easters.add(point);
      } else if (char == 'v') {
        southers.add(point);
      }
    }
  }

  void printFloor() {
    for (var y = 0; y <= maxY; y++) {
      String line = '';
      for (var x = 0; x <= maxX; x++) {
        var point = Point(x, y);
        if (easters.contains(point)) {
          line += '>';
        } else if (southers.contains(point)) {
          line += 'v';
        } else {
          line += '.';
        }
      }

      print(line);
    }
  }

  bool move() {
    var rEasters = <Point>{};
    var rSouthers = <Point>{};

    bool moveEast() {
      var toRemove = <Point>{};
      for (var cucumber in easters) {
        var destination = Point(
          cucumber.x == maxX ? 0 : cucumber.x + 1,
          cucumber.y,
        );
        if (!easters.contains(destination) && !southers.contains(destination)) {
          toRemove.add(cucumber);
          rEasters.add(destination);
        }
      }
      easters.removeAll(toRemove);

      return toRemove.isNotEmpty;
    }

    bool moveSouth() {
      var toRemove = <Point>{};
      for (var cucumber in southers) {
        var destination = Point(
          cucumber.x,
          cucumber.y == maxY ? 0 : cucumber.y + 1,
        );
        if (!easters.contains(destination) &&
            !southers.contains(destination) &&
            !rEasters.contains(destination)) {
          toRemove.add(cucumber);
          rSouthers.add(destination);
        }
      }
      southers.removeAll(toRemove);

      return toRemove.isNotEmpty;
    }

    var east = moveEast();
    var south = moveSouth();

    rEasters.addAll(easters);
    rSouthers.addAll(southers);

    easters = rEasters;
    southers = rSouthers;

    return east || south;
  }

  int count = 1;
  while (move()) {
    count++;
  }
  print(count);
  // printFloor();
}

enum Tile { east, south }
