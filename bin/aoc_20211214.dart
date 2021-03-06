import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var start = lines[0];
  var combiCount = combiCountFromLine(start);
  var instructions = parseInstructions(lines.getRange(2, lines.length));

  for (int i = 0; i < 40; i++) {
    var fCombiCount = <String, int>{};
    for (var combi in combiCount.keys) {
      var insert = instructions[combi]!;
      var c1 = combi.substring(0, 1) + insert;
      var c2 = insert + combi.substring(1, 2);

      if (!fCombiCount.containsKey(c1)) fCombiCount[c1] = 0;
      if (!fCombiCount.containsKey(c2)) fCombiCount[c2] = 0;

      fCombiCount[c1] = fCombiCount[c1]! + combiCount[combi]!;
      fCombiCount[c2] = fCombiCount[c2]! + combiCount[combi]!;
    }
    combiCount = fCombiCount;
  }

  var result = <String, int>{};
  result[start.substring(start.length - 1)] = 1;
  for (var combi in combiCount.keys) {
    var c = combi.substring(0, 1);
    if (!result.containsKey(c)) result[c] = 0;
    result[c] = result[c]! + combiCount[combi]!;
  }

  var maxC = result.keys.fold(0, (int prev, e) => max(prev, result[e]!));
  var minC = result.keys.fold(maxC, (int prev, e) => min(prev, result[e]!));

  print(minC);
  print(maxC);
  print(maxC - minC);
}

Map<String, String> parseInstructions(Iterable<String> lines) {
  var result = <String, String>{};
  for (var line in lines) {
    var parts = line.split(' -> ');
    result[parts[0]] = parts[1];
  }

  return result;
}

Map<String, int> combiCountFromLine(String start) {
  var result = <String, int>{};
  for (int i = 0; i < start.length - 1; i++) {
    var combi = start.substring(i, i + 2);
    if (!result.containsKey(combi)) result[combi] = 0;
    result[combi] = result[combi]! + 1;
  }

  return result;
}
