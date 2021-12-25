import 'dart:io';

// NOT FINISHED

void main(List<String> arguments) {
  var lines = File('./tin').readAsLinesSync();
  // var lines = File('./in').readAsLinesSync();

  var ts = parse(lines);
  print(ts.length);

  var t1427 = ts.firstWhere((element) => element.id == 1427);
  var t2311  = ts.firstWhere((element) => element.id == 2311);
  var t3079   = ts.firstWhere((element) => element.id == 3079);
  // var t = parseTile(lines, 0);
  // print(t);
  // var a = t.rotate().rotate().flipVertically();
  // var b = t.flipHorizontally();
  // print(a == b);
  // print(t == a);
  // print(t == b);
}

void bn(Tile t1, Tile t2) {
 // .. 
}

String reverseString(String str) => str.split('').reversed.join();

List<Tile> parse(List<String> lines) {
  var result = <Tile>[];
  for (int i = 0; i < lines.length; i += 12) {
    result.add(parseTile(lines, i));
  }

  return result;
}

Tile parseTile(List<String> lines, int index) {
  var id = int.parse(
      lines[index].substring('Tile '.length, lines[index].length - 1));

  var north = '', east = '', south = '', west = '';
  for (int i = 0; i < 10; i++) {
    var line = lines[index + 1 + i];
    if (i == 0) north = line;
    if (i == 9) south = line;
    west += line.substring(0, 1);
    east += line.substring(9, 10);
  }

  return Tile(id, north, east, south, west);
}

class Tile {
  final int id;
  final String north, east, south, west;

  Tile(this.id, this.north, this.east, this.south, this.west);

  Tile flipHorizontally() =>
      Tile(id, reverseString(north), west, reverseString(south), east);

  Tile flipVertically() =>
      Tile(id, south, reverseString(east), north, reverseString(west));

  Tile rotate() =>
      Tile(id, reverseString(west), north, reverseString(east), south);

  @override
  String toString() => '$id $north, $east, $south, $west';

  @override
  int get hashCode {
    int result = 37;
    result = 31 * result + id;
    result = 31 * result + north.hashCode;
    result = 31 * result + east.hashCode;
    result = 31 * result + south.hashCode;
    result = 31 * result + west.hashCode;

    return result;
  }

  @override
  bool operator ==(other) =>
      other is Tile &&
      id == other.id &&
      north == other.north &&
      east == other.east &&
      south == other.south &&
      west == other.west;
}
