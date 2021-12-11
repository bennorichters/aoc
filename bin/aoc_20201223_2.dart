import 'dart:collection';

const oneMillion = 1000000;
const tenMillion = 10 * oneMillion;

void main() {
  // const line = '389125467';
  const line = '789465123';

  var circle = LinkedList<Cup>();
  var cups =
      line.split('').map((e) => int.parse(e)).map((e) => Cup(e)).toList();

  circle.addAll(cups);
  cups.sort((a, b) => a.value - b.value);

  for (int i = 10; i <= oneMillion; i++) {
    var cup = Cup(i);
    circle.add(cup);
    cups.add(cup);
  }

  Cup next(Cup c) => (c.next == null) ? circle.first : c.next!;

  var move = circle.first;
  for (var i = 0; i < tenMillion; i++) {
    var pu1 = next(move);
    var pu2 = next(pu1);
    var pu3 = next(pu2);

    var puValues = [pu1.value, pu2.value, pu3.value];
    int findDestination(int candidate) {
      if (candidate == 0) return findDestination(cups.length);
      if (puValues.contains(candidate)) return findDestination(candidate - 1);
      return candidate;
    }

    var dest = findDestination(move.value - 1);
    pu1.unlink();
    pu2.unlink();
    pu3.unlink();

    var after = cups[dest - 1];
    after.insertAfter(pu1);
    pu1.insertAfter(pu2);
    pu2.insertAfter(pu3);

    move = next(move);
  }

  var r1 = next(cups[0]).value;
  var r2 = next(next(cups[0])).value;
  print(r1);
  print(r2);
  print(r1 * r2);
}

class Cup extends LinkedListEntry<Cup> {
  final int value;
  Cup(this.value);

  @override
  String toString() => '$value';
}
