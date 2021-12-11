import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var d1 = readDeck(lines.getRange(1, lines.length));
  var d2 = readDeck(lines.getRange(d1.length + 3, lines.length));

  while (d1.isNotEmpty && d2.isNotEmpty) {
    var c1 = d1.removeAt(0);
    var c2 = d2.removeAt(0);

    if (c1 > c2) {
      d1.add(c1);
      d1.add(c2);
    } else {
      d2.add(c2);
      d2.add(c1);
    }
  }

  var winner = (d1.isEmpty ? d2 : d1).reversed.toList();
  var result = 0;
  for (var i = 0; i < winner.length; i++) {
    result += ((i + 1) * winner[i]).truncate(); 
  }
  print(result);
}

List<int> readDeck(Iterable<String> lines) {
  var result = <int>[];
  for (String line in lines) {
    if (line.isEmpty) break;
    result.add(int.parse(line));
  }

  return result;
}
