import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  int mostUsedValue(List<String> numbers, int bit) {
    int count = numbers.where((e) => int.parse(e[bit]) == 1).length;
    return count >= numbers.length / 2 ? 1 : 0;
  }

  int select(bool most) {
    List<String> left = [...lines];
    for (int x = 0; left.length > 1 && x < left[0].length; x++) {
      var f = mostUsedValue(left, x);
      if (!most) f = 1 - f;
      left.removeWhere((element) => int.parse(element[x]) != f);
    }
    return int.parse(left[0], radix: 2);
  }

  var r1 = select(true);
  var r2 = select(false);

  print(r1 * r2);
}
