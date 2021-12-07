import 'dart:io';

void main(List<String> arguments) {
  solve();
}

void solve() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var turned = initialTurned(lines);

  for (int i = 1; i <= 100; i++) {
    var w = toWhite(turned);
    var b = toBlack(turned);

    turned.removeAll(w);
    turned.addAll(b);

    print('$i, ${turned.length}');
  }
}

enum Instruction { e, se, sw, w, nw, ne }

extension ParseToString on Instruction {
  String toShortString() => toString().split('.').last;
}

Instruction nextInstruction(String line) =>
    Instruction.values.firstWhere((e) => line.startsWith(e.toShortString()));

class CubeCoordinate {
  final int x, y, z;

  CubeCoordinate(this.x, this.y, this.z);

  @override
  String toString() => '[$x, $y, $z]';

  @override
  bool operator ==(other) =>
      (other is CubeCoordinate) && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => x + 31 * y + 101 * z;
}

CubeCoordinate move(CubeCoordinate tile, Instruction instruction) {
  switch (instruction) {
    case Instruction.e:
      return CubeCoordinate(tile.x + 1, tile.y - 1, tile.z);
    case Instruction.se:
      return CubeCoordinate(tile.x, tile.y - 1, tile.z + 1);
    case Instruction.sw:
      return CubeCoordinate(tile.x - 1, tile.y, tile.z + 1);
    case Instruction.w:
      return CubeCoordinate(tile.x - 1, tile.y + 1, tile.z);
    case Instruction.nw:
      return CubeCoordinate(tile.x, tile.y + 1, tile.z - 1);
    case Instruction.ne:
      return CubeCoordinate(tile.x + 1, tile.y, tile.z - 1);
  }
}

bool areAdjacent(CubeCoordinate cc1, CubeCoordinate cc2) =>
    Instruction.values.any((e) => move(cc1, e) == cc2);

Set<CubeCoordinate> initialTurned(List<String> lines) {
  Set<CubeCoordinate> turned = {};
  for (var line in lines) {
    List<Instruction> instructions = [];
    while (line.isNotEmpty) {
      var next = nextInstruction(line);
      instructions.add(next);
      line = line.substring(next.toShortString().length);
    }

    CubeCoordinate tile = CubeCoordinate(0, 0, 0);
    turned.add(tile);
    for (Instruction ins in instructions) {
      tile = move(tile, ins);
    }
    if (!turned.add(tile)) turned.remove(tile);
  }

  return turned;
}

Set<CubeCoordinate> toWhite(Set<CubeCoordinate> blacks) {
  Set<CubeCoordinate> result = {};

  for (var b0 in blacks) {
    var count = 0;
    for (var b1 in blacks) {
      if (areAdjacent(b0, b1)) count++;
    }
    if (count == 0 || count > 2) result.add(b0);
  }

  return result;
}

Set<CubeCoordinate> toBlack(Set<CubeCoordinate> blacks) {
  Set<CubeCoordinate> result = {};

  var candidates = allAdjacent(blacks);
  for (var c in candidates) {
    if (!blacks.contains(c)) {
      var count = 0;
      for (var b in blacks) {
        if (areAdjacent(c, b)) count++;
      }

      if (count == 2) result.add(c);
    }
  }

  return result;
}

Set<CubeCoordinate> allAdjacent(Set<CubeCoordinate> ccs) {
  Set<CubeCoordinate> result = {};
  for (var cc in ccs) {
    result.addAll(Instruction.values.map((e) => move(cc, e)));
  }

  return result;
}
