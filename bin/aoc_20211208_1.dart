import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var count = 0;
  for (var line in lines) {
    var last = (line.split('|')[1]).trim();
    var digits = last.split(' ');
    for (var digit in digits) {
      if ([2, 3, 4, 7].contains(digit.length)) count++;
    }
  }

  print(count);
}
