import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

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

  print(turned.length);
}

enum Instruction { e, se, sw, w, nw, ne }

extension ParseToString on Instruction {
  String toShortString() => toString().split('.').last;
}

Instruction nextInstruction(String line) {
  for (Instruction ins in Instruction.values) {
    if (line.startsWith(ins.toShortString())) {
      return ins;
    }
  }

  throw Exception("no valid instruction found");
}

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
