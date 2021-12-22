import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  solve(parse(lines));
}

void solve(List<Step> steps) {
  var result = <Cuboid>{};

  for (var step in steps) {
    result = executeStep(result, step);
  }

  print(totalLights(result));
}

int totalLights(Set<Cuboid> cuboids) => cuboids.fold(
      0,
      (prev, element) => prev + element.size,
    );

Set<Cuboid> executeStep(Set<Cuboid> cuboids, Step step) {
  if (cuboids.isEmpty && step.turnOn) return {step.cuboid};
  if (cuboids.isEmpty) return <Cuboid>{};

  return step.turnOn
      ? turnLightsOn(cuboids, step.cuboid)
      : turnLightsOff(cuboids, step.cuboid);
}

Set<Cuboid> turnLightsOn(Set<Cuboid> cuboids, Cuboid toAdd) {
  var result = <Cuboid>{toAdd};

  for (var cuboid in cuboids) {
    var extra = <Cuboid>{};
    for (var partOfStep in result) {
      extra.addAll(subtract(partOfStep, cuboid));
    }

    if (extra.isEmpty) return cuboids;

    result = extra;
  }

  result.addAll(cuboids);
  return result;
}

Set<Cuboid> turnLightsOff(Set<Cuboid> cuboids, Cuboid toSubtract) {
  var result = <Cuboid>{};
  for (var cuboid in cuboids) {
    result.addAll(subtract(cuboid, toSubtract));
  }

  return result;
}

Set<Cuboid> subtract(Cuboid target, Cuboid toCutAway) {
  var overlap = overlapping(target, toCutAway);
  if (overlap == null) return {target};

  return cutAroundOverlap(target, overlap);
}

Set<Cuboid> cutAroundOverlap(Cuboid cuboid, Cuboid overlap) {
  var result = <Cuboid>{};

  if (cuboid.corner.x < overlap.corner.x) {
    result.add(cutLeft(cuboid, overlap.corner.x - 1));
    cuboid = cutRight(cuboid, overlap.corner.x);
  }

  if (cuboid.oppositeCorner.x > overlap.oppositeCorner.x) {
    result.add(cutRight(cuboid, overlap.oppositeCorner.x + 1));
    cuboid = cutLeft(cuboid, overlap.oppositeCorner.x);
  }

  if (cuboid.corner.y < overlap.corner.y) {
    result.add(cutBottom(cuboid, overlap.corner.y - 1));
    cuboid = cutTop(cuboid, overlap.corner.y);
  }

  if (cuboid.oppositeCorner.y > overlap.oppositeCorner.y) {
    result.add(cutTop(cuboid, overlap.oppositeCorner.y + 1));
    cuboid = cutBottom(cuboid, overlap.oppositeCorner.y);
  }

  if (cuboid.corner.z < overlap.corner.z) {
    result.add(cutFront(cuboid, overlap.corner.z - 1));
    cuboid = cutBack(cuboid, overlap.corner.z);
  }

  if (cuboid.oppositeCorner.z > overlap.oppositeCorner.z) {
    result.add(cutBack(cuboid, overlap.oppositeCorner.z + 1));
    cuboid = cutFront(cuboid, overlap.oppositeCorner.z);
  }

  assert(cuboid == overlap);

  return result;
}

Cuboid cutBack(Cuboid c2, int fromZ) => Cuboid(
      corner: CubeCoordinate(
        c2.corner.x,
        c2.corner.y,
        fromZ,
      ),
      width: c2.width,
      height: c2.height,
      depth: c2.oppositeCorner.z - fromZ + 1,
    );

Cuboid cutFront(Cuboid c2, int toZ) => Cuboid(
      corner: c2.corner,
      width: c2.width,
      height: c2.height,
      depth: toZ - c2.corner.z + 1,
    );

Cuboid cutTop(Cuboid c2, int fromY) => Cuboid(
      corner: CubeCoordinate(
        c2.corner.x,
        fromY,
        c2.corner.z,
      ),
      width: c2.width,
      height: c2.oppositeCorner.y - fromY + 1,
      depth: c2.depth,
    );

Cuboid cutBottom(Cuboid c2, int toY) => Cuboid(
      corner: c2.corner,
      width: c2.width,
      height: toY - c2.corner.y + 1,
      depth: c2.depth,
    );

Cuboid cutRight(Cuboid c2, int fromX) => Cuboid(
      corner: CubeCoordinate(
        fromX,
        c2.corner.y,
        c2.corner.z,
      ),
      width: c2.oppositeCorner.x - fromX + 1,
      height: c2.height,
      depth: c2.depth,
    );

Cuboid cutLeft(Cuboid c2, int toX) => Cuboid(
      corner: c2.corner,
      width: toX - c2.corner.x + 1,
      height: c2.height,
      depth: c2.depth,
    );

Cuboid? overlapping(Cuboid c1, Cuboid c2) {
  var x1 = max(c1.corner.x, c2.corner.x);
  var y1 = max(c1.corner.y, c2.corner.y);
  var z1 = max(c1.corner.z, c2.corner.z);

  var x2 = min(c1.oppositeCorner.x, c2.oppositeCorner.x);
  var y2 = min(c1.oppositeCorner.y, c2.oppositeCorner.y);
  var z2 = min(c1.oppositeCorner.z, c2.oppositeCorner.z);

  return (x2 >= x1 && y2 >= y1 && z2 >= z1)
      ? Cuboid.fromOppositeCorners(
          CubeCoordinate(x1, y1, z1),
          CubeCoordinate(x2, y2, z2),
        )
      : null;
}

class Step {
  final bool turnOn;
  final Cuboid cuboid;
  Step(this.turnOn, this.cuboid);

  @override
  String toString() => '{${turnOn ? 'ON ' : 'OFF'}, $cuboid}';
}

class Cuboid {
  final CubeCoordinate corner;
  final int width, height, depth;
  const Cuboid({
    required this.corner,
    required this.width,
    required this.height,
    required this.depth,
  }) : assert(width > 0 && height > 0 && depth > 0);

  Cuboid.fromOppositeCorners(CubeCoordinate c1, CubeCoordinate c2)
      : this(
          corner: c1,
          width: c2.x - c1.x + 1,
          height: c2.y - c1.y + 1,
          depth: c2.z - c1.z + 1,
        );

  int get size => width * height * depth;

  CubeCoordinate get oppositeCorner => CubeCoordinate(
        corner.x + width - 1,
        corner.y + height - 1,
        corner.z + depth - 1,
      );

  @override
  int get hashCode => width + 13 * height + 19 * depth + 31 * corner.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Cuboid &&
      corner == other.corner &&
      width == other.width &&
      height == other.height &&
      depth == other.depth;

  @override
  String toString() =>
      'Cuboid corner:$corner, width:$width, height:$height, depth:$depth';
}

class CubeCoordinate {
  final int x, y, z;
  const CubeCoordinate(this.x, this.y, this.z);

  CubeCoordinate operator +(other) => CubeCoordinate(
        (x + other.x).truncate(),
        (y + other.y).truncate(),
        (z + other.z).truncate(),
      );

  CubeCoordinate operator -(other) => CubeCoordinate(
        (x - other.x).truncate(),
        (y - other.y).truncate(),
        (z - other.z).truncate(),
      );

  @override
  String toString() => '[$x, $y, $z]';

  @override
  bool operator ==(other) =>
      other is CubeCoordinate && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => x + 31 * y + 101 * z;
}

List<Step> parse(List<String> lines) {
  List<Step> result = [];
  for (var line in lines) {
    var parts = line.split(' ');

    var ranges = parts[1].split(',');
    var xs = splitInts(ranges[0]);
    var ys = splitInts(ranges[1]);
    var zs = splitInts(ranges[2]);

    result.add(
      Step(
        parts[0] == 'on',
        Cuboid.fromOppositeCorners(
          CubeCoordinate(
            min(xs[0], xs[1]),
            min(ys[0], ys[1]),
            min(zs[0], zs[1]),
          ),
          CubeCoordinate(
            max(xs[0], xs[1]),
            max(ys[0], ys[1]),
            max(zs[0], zs[1]),
          ),
        ),
      ),
    );
  }

  return result;
}

List<int> splitInts(String input) {
  var parts = input.substring('.='.length).split('..');
  return [int.parse(parts[0]), int.parse(parts[1])];
}
