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

  List<List<String>> walk() {
    List<List<String>> result = [];

    void rec(List<String> path) {
      if (path.last == 'end') {
        result.add(path);
        return;
      }

      for (var n in caveMap[path.last]!) {
        if (n.toUpperCase() == n || !path.contains(n)) {
          var rPath = List.of(path);
          rPath.add(n);
          rec(rPath);
        }
      }
    }

    rec(['start']);
    return result;
  }

  var paths = walk();
  print(paths.length);
}

