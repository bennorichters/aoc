import 'dart:io';
import 'package:collection/collection.dart';

const segments = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

const normalWiringDigits = [
  {'a', 'b', 'c', 'e', 'f', 'g'},
  {'c', 'f'},
  {'a', 'c', 'd', 'e', 'g'},
  {'a', 'c', 'd', 'f', 'g'},
  {'b', 'c', 'd', 'f'},
  {'a', 'b', 'd', 'f', 'g'},
  {'a', 'b', 'd', 'e', 'f', 'g'},
  {'a', 'c', 'f'},
  {'a', 'b', 'c', 'd', 'e', 'f', 'g'},
  {'a', 'b', 'c', 'd', 'f', 'g'},
];

void main() {
  var all = allPossibleWirings();

  var lines = File('./tin').readAsLinesSync();
  // var lines = File('./in').readAsLinesSync();

  var result = 0;
  for (var line in lines) {
    var parts = line.split('|');
    var signalPatterns = parts[0].trim().split(' ');
    var output = parts[1].trim().split(' ');

    var wiring = all.firstWhere((e) => patternMatches(e, signalPatterns));
    var number = 0;
    for (var value in output) {
      number *= 10;
      number += valueToInt(wiring, value.split(''));
    }
    print(number);
    result += number;
  }

  print('answer: $result');
}

bool patternMatches(List<String> wiring, List<String> signalPatterns) {
  Set<int> zeroToTen = {};
  for (var pattern in signalPatterns) {
    var r = valueToInt(wiring, pattern.split(''));
    if (r == -1 || !zeroToTen.add(r)) return false;
  }

  return true;
}

int valueToInt(List<String> wiring, List<String> value) {
  Set<String> translated =
      value.map((e) => segments[wiring.indexOf(e)]).toSet();

  return normalWiringDigits
      .indexWhere((element) => SetEquality().equals(element, translated));
}

Set<List<String>> allPossibleWirings() {
  Set<List<String>> result = {};
  void rec(List<String> entry, List<String> rest) {
    if (rest.isEmpty) result.add(entry);

    for (int i = 0; i < rest.length; i++) {
      List<String> recResult = List.from(entry);
      recResult.add(rest[i]);

      List<String> recRest = List.from(rest);
      recRest.removeAt(i);

      rec(recResult, recRest);
    }
  }

  rec([], segments);
  return result;
}
