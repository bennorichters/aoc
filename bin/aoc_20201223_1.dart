void main() {
  // var line = '389125467';
  const line = '789465123';
  var circle = line.split('').map((e) => int.parse(e)).toList();

  int nextIndex(int i) => (i >= circle.length - 1) ? 0 : i + 1;

  var index = 0;
  for (int i = 0; i < 100; i++) {
    var move = circle[index];

    var pickedUp = <int>[];
    int pickUpIndex = index;
    for (int j = 0; j < 3; j++) {
      pickUpIndex = nextIndex(pickUpIndex);
      pickedUp.add(circle[pickUpIndex]);
    }

    int findDestination(int candidate) {
      if (candidate == 0) return findDestination(9);
      if (pickedUp.contains(candidate)) return findDestination(candidate - 1);

      return candidate;
    }

    var destination = findDestination(move - 1);

    for (int j = 0; j < 3; j++) {
      circle.remove(pickedUp[j]);
    }
    var destIndex = circle.indexOf(destination) + 1;
    circle.insertAll(destIndex, pickedUp);

    index = nextIndex(circle.indexOf(move));
  }

  var result = [];
  var ri = circle.indexOf(1);
  for (int i = 0; i < 8; i++) {
    ri = nextIndex(ri);
    result.add(circle[ri]);
  }
  print(result.join());
}
