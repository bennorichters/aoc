import 'dart:io';
import 'dart:math';

void main() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var maxY = lines.length - 1;
  var maxX = lines[0].length - 1;
  var floor = <Point, Tile>{};
  var easters = <Point>{};
  var southers = <Point>{};
  for (var y = 0; y <= maxY; y++) {
    for (var x = 0; x <= maxX; x++) {
      var char = lines[y].substring(x, x + 1);
      var point = Point(x, y);
      if (char == '>') {
        floor[point] = Tile.east;
        easters.add(point);
      } else if (char == 'v') {
        floor[point] = Tile.south;
        southers.add(point);
      }
    }
  }

  void printFloor() {
    for (var y = 0; y <= maxY; y++) {
      String line = '';
      for (var x = 0; x <= maxX; x++) {
        var point = Point(x, y);
        line += floor.containsKey(point)
            ? (floor[point] == Tile.east ? '>' : 'v')
            : '.';
      }

      print(line);
    }
  }

  bool move() {
    var rFloor = <Point, Tile>{};
    var rEasters = <Point>{};
    var rSouthers = <Point>{};

    bool moveEast() {
      var toRemove = <Point>{};
      for (var cucumber in easters) {
        var destination = Point(
          cucumber.x == maxX ? 0 : cucumber.x + 1,
          cucumber.y,
        );
        if (!floor.containsKey(destination)) {
          toRemove.add(cucumber);
          rFloor[destination] = Tile.east;
          rEasters.add(destination);
        }
      }
      for (var rem in toRemove) {
        floor.remove(rem);
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
        if (!rFloor.containsKey(destination) &&
            !floor.containsKey(destination)) {
          toRemove.add(cucumber);
          rFloor[destination] = Tile.south;
          rSouthers.add(destination);
        }
      }
      for (var rem in toRemove) {
        floor.remove(rem);
      }
      southers.removeAll(toRemove);

      return toRemove.isNotEmpty;
    }

    var east = moveEast();
    var south = moveSouth();

    rFloor.addAll(floor);
    rEasters.addAll(easters);
    rSouthers.addAll(southers);

    floor = rFloor;
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
  // for (int step = 1; step <= 20; step++) {
  //   print('$step ##################');
  //   move();
  //   printFloor();
  //   print('');
  // }
}

typedef Cucumbers = Set<Point>;
typedef FloorMap = Map<Point, Tile>;

enum Tile { east, south }
