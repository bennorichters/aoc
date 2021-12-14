import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var instructions = {};
  for (int i = 2; i < lines.length; i++) {
    var parts = lines[i].split(' -> ');
    instructions[parts[0]] = parts[1];
  }

  var start = lines[0];
  var combiCount = calcCombiCount(start);

  for (int i = 0; i < 40; i++) {
    var fCombiCount = <String, int>{};
    for (var combi in combiCount.keys) {
      var p1 = combi.substring(0, 1);
      var p2 = combi.substring(1, 2);

      var insert = instructions[combi]!;
      var c1 = p1 + insert;
      var c2 = insert + p2;

      if (!fCombiCount.containsKey(c1)) fCombiCount[c1] = 0;
      if (!fCombiCount.containsKey(c2)) fCombiCount[c2] = 0;

      fCombiCount[c1] = fCombiCount[c1]! + combiCount[combi]!;
      fCombiCount[c2] = fCombiCount[c2]! + combiCount[combi]!;
    }
    combiCount = fCombiCount;
  }

  var result = <String, int>{};
  for (var combi in combiCount.keys) {
    var c = combi.substring(0, 1);
    if (!result.containsKey(c)) {
      result[c] = 0;
    }
    result[c] = result[c]! + combiCount[combi]!;
  }

  var maxC = result.keys.fold(
      0, (int prev, e) => max(prev, result[e]! + (start.endsWith(e) ? 1 : 0)));
  var minC = result.keys.fold(maxC, (int prev, e) => min(prev, result[e]!));

  print(minC);
  print(maxC);
  print(maxC - minC);
}

Map<String, int> calcCombiCount(String start) {
  var combiCount = <String, int>{};
  for (int i = 0; i < start.length - 1; i++) {
    var combi = start.substring(i, i + 2);
    if (!combiCount.containsKey(combi)) {
      combiCount[combi] = 0;
    }
    combiCount[combi] = combiCount[combi]! + 1;
  }

  return combiCount;
}
