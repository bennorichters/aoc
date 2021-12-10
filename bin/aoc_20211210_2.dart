import 'dart:io';

const openers = ['(', '[', '{', '<'];
const closers = [')', ']', '}', '>'];

void main() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var scores = [];
  for (var line in lines) {
    var unclosed = unclosedPart(line);
    if (unclosed.isNotEmpty) {
      var rest = unclosed.split('').reversed;
      var score = 0;
      for (String b in rest) {
        score *= 5;
        score += openers.indexOf(b) + 1;
      }
      scores.add(score);
    }
  }

  scores.sort();
  print(scores[scores.length ~/ 2]);
}

String unclosedPart(String line) {
  for (var i = 0; i < line.length;) {
    String char = line.substring(i, i + 1);
    if (closers.contains(char)) {
      if (i == 0) return char;
      var ci = closers.indexOf(char);
      if (line.substring(i - 1, i) != openers[ci]) return '';

      line = line.substring(0, i - 1) + line.substring(i + 1);
      i--;
    } else {
      i++;
    }
  }

  return line;
}
