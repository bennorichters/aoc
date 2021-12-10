import 'dart:io';

const openers = ['(', '[', '{', '<'];
const closers = [')', ']', '}', '>'];
const scores = [3, 57, 1197, 25137];

void main() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  int score = 0;
  for (var line in lines) {
    var offender = findOffender(line);
    if (closers.contains(offender)) score += scores[closers.indexOf(offender)];
  }

  print(score);
}

String findOffender(String line) {
  var i = 0;
  while (i < line.length) {
    String char = line.substring(i, i + 1);
    if (closers.contains(char)) {
      if (i == 0) return char;
      var ci = closers.indexOf(char);
      if (line.substring(i - 1, i) != openers[ci]) return char;

      line = line.substring(0, i - 1) + line.substring(i + 1);
      i--;
    } else {
      i++;
    }
  }

  return '';
}
