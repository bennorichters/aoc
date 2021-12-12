import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var caveMap = <String, Set<String>>{};
  for (var line in lines) {
    var parts = line.split('-');
    caveMap.putIfAbsent(parts[0], () => <String>{}).add(parts[1]);
    caveMap.putIfAbsent(parts[1], () => <String>{}).add(parts[0]);
  }

  int walk() {
    var result = 0;

    void rec(List<String> path, bool twiceSmall) {
      if (path.last == 'end') {
        result++;
        return;
      }

      for (var n in caveMap[path.last]!) {
        if (n != 'start' &&
            (n.toUpperCase() == n || !twiceSmall || !path.contains(n))) {
          var rPath = List.of(path);
          rPath.add(n);
          rec(rPath, twiceSmall || (n.toLowerCase() == n && path.contains(n)));
        }
      }
    }

    rec(['start'], false);
    return result;
  }

  print(walk());
}
