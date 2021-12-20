import 'dart:io';
import 'dart:math';

const referenceScanner = CubeCoordinate(0, 0, 0);

void main() {
  var lines = File('./tin').readAsLinesSync();
  // var lines = File('./in').readAsLinesSync();

  var scans = parseAllScanners(lines);
  var rotations = all24Rotations();

  void solve() {
    var visited = <int>{};
    var beacons = Set.of(scans[0]);
    var scanners = Set.of({referenceScanner});

    void addFoundResults(
      Set<CubeCoordinate> scanB,
      Transformation tr,
      List<Transformation> steps,
    ) {
      for (var beacon in scanB) {
        var scanner = tr.perform(referenceScanner);
        beacon = tr.perform(beacon);
        for (var step in steps.reversed) {
          scanner = step.perform(scanner);
          beacon = step.perform(beacon);
        }
        scanners.add(scanner);
        beacons.add(beacon);
      }
    }

    Transformation? tryAllRotations(
      Set<CubeCoordinate> scanA,
      Set<CubeCoordinate> scanB,
      CubeCoordinate beaconA,
      List<Transformation> steps,
    ) {
      for (var rotation in rotations) {
        for (var beaconB in scanB) {
          var translation = beaconA - rotation.perform(beaconB);
          var tr = Transformation(translation, rotation);
          if (areOverlapping(scanA, scanB, tr)) {
            addFoundResults(scanB, tr, steps);

            return tr;
          }
        }
      }

      return null;
    }

    Transformation? findTransformation(
      Set<CubeCoordinate> scanA,
      Set<CubeCoordinate> scanB,
      List<Transformation> steps,
    ) {
      for (var beaconA in scanA) {
        var tr = tryAllRotations(scanA, scanB, beaconA, steps);
        if (tr != null) return tr;
      }

      return null;
    }

    void overlapWithOtherScans(int scan, List<Transformation> steps) {
      if (!visited.add(scan)) return;

      print(scan);

      var scanA = scans[scan];
      for (var other = 0; other < scans.length; other++) {
        if (!visited.contains(other)) {
          var tr = findTransformation(scanA, scans[other], steps);
          if (tr != null) overlapWithOtherScans(other, List.of(steps)..add(tr));
        }
      }
    }

    overlapWithOtherScans(0, []);

    print('nr of beacons: ${beacons.length}');
    print('max ditance between scanners: ${maxDistance(scanners.toList())}');
  }

  solve();
}

int maxDistance(List<CubeCoordinate> coords) {
  var maxDist = 0;
  for (int i = 0; i < coords.length; i++) {
    for (int j = i + 1; j < coords.length; j++) {
      var c1 = coords[i];
      var c2 = coords[j];
      var dist =
          (c1.x - c2.x).abs() + (c1.y - c2.y).abs() + (c1.z - c2.z).abs();
      maxDist = max(maxDist, dist);
    }
  }

  return maxDist;
}

class Transformation {
  final CubeCoordinate translation;
  final Rotation rotation;
  Transformation(this.translation, this.rotation);

  CubeCoordinate perform(CubeCoordinate c) => rotation.perform(c) + translation;

  @override
  String toString() => '$translation $rotation';
}

bool areOverlapping(
  Set<CubeCoordinate> scanA,
  Set<CubeCoordinate> scanB,
  Transformation transformation,
) {
  var count = 0;
  for (var sa in scanA) {
    for (var sb in scanB) {
      if (transformation.perform(sb) == sa) {
        count++;
        if (count == 12) return true;
      }
    }
  }

  return false;
}

List<Set<CubeCoordinate>> parseAllScanners(List<String> lines) {
  var result = <Set<CubeCoordinate>>[];
  for (int i = 1; i < lines.length;) {
    var parsed = parseScanner(lines, i);
    result.add(parsed);
    i += parsed.length + 2;
  }

  return result;
}

Set<CubeCoordinate> parseScanner(List<String> lines, int start) {
  var result = <CubeCoordinate>{};
  for (int i = start; i < lines.length && lines[i].isNotEmpty; i++) {
    var parts = lines[i].split(',');
    result.add(CubeCoordinate(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    ));
  }

  return result;
}

Set<Rotation> all24Rotations() {
  const c = CubeCoordinate(1, 2, 3);

  var all = <CubeCoordinate, Set<List<AxisRotation>>>{};
  for (int x = 0; x < 4; x++) {
    var tx = Angle.values[x];
    var rx = rotateX(c, tx);
    var instructionsX = <AxisRotation>[];
    instructionsX.add(AxisRotation(Axis.x, tx));
    all.putIfAbsent(rx, () => {}).add(instructionsX);
    for (int y = 0; y < 4; y++) {
      var ty = Angle.values[y];
      var ry = rotateY(rx, ty);
      var instructionsY = List.of(instructionsX)..add(AxisRotation(Axis.y, ty));
      all.putIfAbsent(ry, () => {}).add(instructionsY);
      for (int z = 0; z < 4; z++) {
        var tz = Angle.values[z];
        var rz = rotateZ(ry, tz);
        var instructionsZ = List.of(instructionsY)
          ..add(AxisRotation(Axis.z, tz));
        all.putIfAbsent(rz, () => {}).add(instructionsZ);
      }
    }
  }

  var result = <Rotation>{};
  for (var k in all.keys) {
    var ins = all[k]!.fold(
      all[k]!.first,
      (List<AxisRotation> p, List<AxisRotation> e) =>
          p.length <= e.length ? p : e,
    );

    result.add(Rotation(ins));
  }
  return result;
}

enum Axis { x, y, z }

class Rotation {
  final List<AxisRotation> axisRotations;
  Rotation(this.axisRotations);

  CubeCoordinate perform(CubeCoordinate c) {
    for (var ar in axisRotations) {
      c = ar.perform(c);
    }
    return c;
  }

  @override
  String toString() => axisRotations.toString();
}

class AxisRotation {
  final Axis axis;
  final Angle theta;
  AxisRotation(this.axis, this.theta);

  CubeCoordinate perform(CubeCoordinate c) {
    switch (axis) {
      case Axis.x:
        return rotateX(c, theta);
      case Axis.y:
        return rotateY(c, theta);
      case Axis.z:
        return rotateZ(c, theta);
    }
  }

  @override
  String toString() => 'Instruction: $axis $theta';
}

enum Angle { theta0, theta90, theta180, theta270 }

CubeCoordinate rotateX(CubeCoordinate c, Angle theta) => CubeCoordinate(
      c.x,
      c.y * cos(theta) - c.z * sin(theta),
      c.y * sin(theta) + c.z * cos(theta),
    );

CubeCoordinate rotateY(CubeCoordinate c, Angle theta) => CubeCoordinate(
      c.x * cos(theta) + c.z * sin(theta),
      c.y,
      c.z * cos(theta) - c.x * sin(theta),
    );

CubeCoordinate rotateZ(CubeCoordinate c, Angle theta) => CubeCoordinate(
      c.x * cos(theta) - c.y * sin(theta),
      c.x * sin(theta) + c.y * cos(theta),
      c.z,
    );

int cos(Angle theta) {
  switch (theta) {
    case Angle.theta0:
      return 1;
    case Angle.theta90:
      return 0;
    case Angle.theta180:
      return -1;
    case Angle.theta270:
      return 0;
  }
}

int sin(Angle theta) {
  switch (theta) {
    case Angle.theta0:
      return 0;
    case Angle.theta90:
      return 1;
    case Angle.theta180:
      return 0;
    case Angle.theta270:
      return -1;
  }
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
      (other is CubeCoordinate) && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => x + 31 * y + 101 * z;
}
