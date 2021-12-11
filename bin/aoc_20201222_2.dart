import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var d1 = readDeck(lines.getRange(1, lines.length));
  var d2 = readDeck(lines.getRange(d1.length + 3, lines.length));

  var winner = play(d1, d2);

  var winList = (winner == 1 ? d1 : d2).reversed.toList();
  var result = 0;
  for (var i = 0; i < winList.length; i++) {
    result += ((i + 1) * winList[i]).truncate();
  }
  print(result);
}

int play(List<int> d1, List<int> d2) {
  var prev1 = <String>{};
  var prev2 = <String>{};
  while (d1.isNotEmpty && d2.isNotEmpty) {
    if (!prev1.add(d1.join(',')) || !prev2.add(d2.join(','))) return 1;

    var c1 = d1.removeAt(0);
    var c2 = d2.removeAt(0);

    var winner = (c1 <= d1.length && c2 <= d2.length)
        ? play(List.of(d1.getRange(0, c1)), List.of(d2.getRange(0, c2)))
        : c1 > c2
            ? 1
            : 2;

    if (winner == 1) {
      d1.add(c1);
      d1.add(c2);
    } else {
      d2.add(c2);
      d2.add(c1);
    }
  }

  return (d1.isEmpty) ? 2 : 1;
}

List<int> readDeck(Iterable<String> lines) {
  var result = <int>[];
  for (String line in lines) {
    if (line.isEmpty) break;
    result.add(int.parse(line));
  }

  return result;
}
