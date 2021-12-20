import 'dart:io';

void main() {
  var lines = File('./tin').readAsLinesSync();
  // var lines = File('./in').readAsLinesSync();

  var scans = parseAllScanners(lines);
  var rotations = allRotations();

  void solve() {
    var visited = <int>{};
    var result = Set.of(scans[0]);

    Transformation? findTransformation(
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
            for (var beaconToAdd in scanB) {
              beaconToAdd = tr.perform(beaconToAdd);
              for (var step in steps.reversed) {
                beaconToAdd = step.perform(beaconToAdd);
              }
              result.add(beaconToAdd);
            }

            return tr;
          }
        }
      }

      return null;
    }

    void compareScans(int scanNrA, List<Transformation> steps) {
      if (!visited.add(scanNrA)) return;

      print(scanNrA);

      var scanA = scans[scanNrA];
      for (var scanNrB = 0; scanNrB < scans.length; scanNrB++) {
        if (!visited.contains(scanNrB)) {
          for (var beaconA in scanA) {
            var tr = findTransformation(scanA, scans[scanNrB], beaconA, steps);
            if (tr != null) {
              var recSteps = List.of(steps)..add(tr);
              compareScans(scanNrB, recSteps);
              break;
            }
          }
        }
      }
    }

    compareScans(0, []);
    print(result.length);
  }

  solve();
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

Set<Rotation> allRotations() {
  var c = CubeCoordinate(1, 2, 3);

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

// X = x;
// Y = y*cos(theta) - z*sin(theta);
// Z = y*sin(theta) + z*cos(theta);
CubeCoordinate rotateX(CubeCoordinate c, Angle theta) => CubeCoordinate(
      c.x,
      c.y * cos(theta) - c.z * sin(theta),
      c.y * sin(theta) + c.z * cos(theta),
    );

// X = x*cos(theta) + z*sin(theta);
// Y = y;
// Z = z*cos(theta) - x*sin(theta);
CubeCoordinate rotateY(CubeCoordinate c, Angle theta) => CubeCoordinate(
      c.x * cos(theta) + c.z * sin(theta),
      c.y,
      c.z * cos(theta) - c.x * sin(theta),
    );

// X = x*cos(theta) - y*sin(theta);
// Y = x*sin(theta) + y*cos(theta);
// Z = z;
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

class CubeCoordinate implements Comparable<CubeCoordinate> {
  final int x, y, z;

  CubeCoordinate(this.x, this.y, this.z);

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

  @override
  int compareTo(CubeCoordinate other) {
    if (x != other.x) return x - other.x;
    if (y != other.y) return y - other.y;
    return z - other.z;
  }
}
