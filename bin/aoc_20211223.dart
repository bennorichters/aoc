import 'dart:math';
import 'package:collection/collection.dart';

// // Puzzle puzzel input #1
// final allAmphipods = {
//   Amphipod(AmphipodType.b, burrow: const Burrow(2, 0)),
//   Amphipod(AmphipodType.a, burrow: const Burrow(2, 1)),
//   Amphipod(AmphipodType.c, burrow: const Burrow(4, 0)),
//   Amphipod(AmphipodType.d, burrow: const Burrow(4, 1)),
//   Amphipod(AmphipodType.b, burrow: const Burrow(6, 0)),
//   Amphipod(AmphipodType.c, burrow: const Burrow(6, 1)),
//   Amphipod(AmphipodType.d, burrow: const Burrow(8, 0)),
//   Amphipod(AmphipodType.a, burrow: const Burrow(8, 1)),
// };

// // Puzzle puzzel input #2
// final allAmphipods = {
//   Amphipod(AmphipodType.b, burrow: const Burrow(2, 0)),
//   Amphipod(AmphipodType.d, burrow: const Burrow(2, 1)),
//   Amphipod(AmphipodType.d, burrow: const Burrow(2, 2)),
//   Amphipod(AmphipodType.a, burrow: const Burrow(2, 3)),
//   Amphipod(AmphipodType.c, burrow: const Burrow(4, 0)),
//   Amphipod(AmphipodType.c, burrow: const Burrow(4, 1)),
//   Amphipod(AmphipodType.b, burrow: const Burrow(4, 2)),
//   Amphipod(AmphipodType.d, burrow: const Burrow(4, 3)),
//   Amphipod(AmphipodType.b, burrow: const Burrow(6, 0)),
//   Amphipod(AmphipodType.b, burrow: const Burrow(6, 1)),
//   Amphipod(AmphipodType.a, burrow: const Burrow(6, 2)),
//   Amphipod(AmphipodType.c, burrow: const Burrow(6, 3)),
//   Amphipod(AmphipodType.d, burrow: const Burrow(8, 0)),
//   Amphipod(AmphipodType.a, burrow: const Burrow(8, 1)),
//   Amphipod(AmphipodType.c, burrow: const Burrow(8, 2)),
//   Amphipod(AmphipodType.a, burrow: const Burrow(8, 3)),
// };

// // Real puzzel input #1
// final allAmphipods = {
//   Amphipod(AmphipodType.c, burrow: const Burrow(2, 0)),
//   Amphipod(AmphipodType.b, burrow: const Burrow(2, 1)),
//   Amphipod(AmphipodType.a, burrow: const Burrow(4, 0)),
//   Amphipod(AmphipodType.a, burrow: const Burrow(4, 1)),
//   Amphipod(AmphipodType.b, burrow: const Burrow(6, 0)),
//   Amphipod(AmphipodType.d, burrow: const Burrow(6, 1)),
//   Amphipod(AmphipodType.d, burrow: const Burrow(8, 0)),
//   Amphipod(AmphipodType.c, burrow: const Burrow(8, 1)),
// };

// Real puzzel input #2
final allAmphipods = {
  Amphipod(AmphipodType.c, burrow: const Burrow(2, 0)),
  Amphipod(AmphipodType.d, burrow: const Burrow(2, 1)),
  Amphipod(AmphipodType.d, burrow: const Burrow(2, 2)),
  Amphipod(AmphipodType.b, burrow: const Burrow(2, 3)),
  Amphipod(AmphipodType.a, burrow: const Burrow(4, 0)),
  Amphipod(AmphipodType.c, burrow: const Burrow(4, 1)),
  Amphipod(AmphipodType.b, burrow: const Burrow(4, 2)),
  Amphipod(AmphipodType.a, burrow: const Burrow(4, 3)),
  Amphipod(AmphipodType.b, burrow: const Burrow(6, 0)),
  Amphipod(AmphipodType.b, burrow: const Burrow(6, 1)),
  Amphipod(AmphipodType.a, burrow: const Burrow(6, 2)),
  Amphipod(AmphipodType.d, burrow: const Burrow(6, 3)),
  Amphipod(AmphipodType.d, burrow: const Burrow(8, 0)),
  Amphipod(AmphipodType.a, burrow: const Burrow(8, 1)),
  Amphipod(AmphipodType.c, burrow: const Burrow(8, 2)),
  Amphipod(AmphipodType.c, burrow: const Burrow(8, 3)),
};

final initialOccupants = (() {
  var result = <Burrow, Amphipod>{};

  for (var amp in allAmphipods) {
    result[amp.burrow!] = amp;
  }

  return result;
})();

final allBurrows = initialOccupants.keys;

final maxDepth = allBurrows.fold(0, (int a, b) => max(a, b.deep));

var burrowsPerType = <AmphipodType, List<Burrow>>{
  AmphipodType.a: List.generate(maxDepth + 1, (index) => Burrow(2, index)),
  AmphipodType.b: List.generate(maxDepth + 1, (index) => Burrow(4, index)),
  AmphipodType.c: List.generate(maxDepth + 1, (index) => Burrow(6, index)),
  AmphipodType.d: List.generate(maxDepth + 1, (index) => Burrow(8, index)),
};

main() {
  solve();
}

void solve() {
  int result = -1;
  var visited = <GameState, int>{};

  var emptyHallway = List.generate(11, (index) => null);
  var gs = GameState(allAmphipods, emptyHallway, initialOccupants);
  gs.printMap();

  var stack = PriorityQueue<StackElement>()..add(StackElement(gs, 0));

  var count = 0;
  while (stack.isNotEmpty) {
    var stackElement = stack.removeFirst();

    var state = stackElement.state;

    if (result > -1 && state.minCosts() + stackElement.energyUsed >= result) {
      continue;
    }

    if (visited.containsKey(state) &&
        visited[state]! <= stackElement.energyUsed) {
      continue;
    }

    visited[state] = stackElement.energyUsed;

    if (state.finished) {
      result = result == -1
          ? stackElement.energyUsed
          : min(result, stackElement.energyUsed);

          print('---Yeah!----');
          state.printMap();
          print(result);
          print('---Yeah!----');

      continue;
    }

    count++;
    if (count % 10000 == 0) {
      print('-------------- $result');
      state.printMap();
    }

    for (var amp in state.amps) {
      var pm = possibleMoves(state, amp, stackElement.energyUsed);
      stack.addAll(pm);
    }
  }

  print(result);
}

class StackElement implements Comparable<StackElement> {
  final GameState state;
  final int energyUsed;
  StackElement(this.state, this.energyUsed);

  @override
  int compareTo(StackElement other) {
    var a = state.compareTo(other.state);
    if (a != 0) return a;

    return energyUsed - other.energyUsed;
  }
}

Set<StackElement> possibleMoves(GameState state, Amphipod amp, int energy) {
  assert(state.amps.contains(amp));
  assert(amp.hallway == -1 || state.hallway[amp.hallway] == amp);
  assert(amp.burrow == null || state.burrows[amp.burrow] == amp);
  assert(amp.hallway > -1 || amp.burrow != null);

  if (amp.finished) return {};

  var result = <StackElement>{};

  if (amp.burrow == null) {
    var b = accessibleBurrows(state, amp);
    if (b != null) {
      var rgs = state.moveToBurrow(amp, b);
      var distance = (b.deep + 1) + (amp.hallway - b.number).abs();
      result.add(StackElement(rgs, energy + amp.energyCost * distance));
    }
  } else {
    if (!canMoveOut(state, amp.burrow!)) return {};
    var hs = accessibleHallway(state, amp);
    for (int h in hs) {
      var rgs = state.moveToHallway(amp, h);
      var distance = (amp.burrow!.deep + 1) + ((amp.burrow!.number) - h).abs();
      result.add(StackElement(rgs, energy + amp.energyCost * distance));
    }
  }

  return result;
}

bool canMoveOut(GameState state, Burrow burrow) {
  for (int i = 0; i < burrow.deep; i++) {
    if (state.burrows.containsKey(Burrow(burrow.number, i))) return false;
  }
  return true;
}

Set<int> accessibleHallway(GameState state, Amphipod amp) {
  const forbidden = {2, 4, 6, 8};
  var result = <int>{};

  for (var left = amp.burrow!.number - 1;
      left >= 0 && state.hallway[left] == null;
      left--) {
    if (!forbidden.contains(left) &&
        !isBlocking(state.hallway, amp.type, left)) {
      result.add(left);
    }
  }

  for (var right = amp.burrow!.number + 1;
      right < state.hallway.length && state.hallway[right] == null;
      right++) {
    if (!forbidden.contains(right) &&
        !isBlocking(state.hallway, amp.type, right)) {
      result.add(right);
    }
  }

  return result;
}

bool isBlocking(List<Amphipod?> ams, AmphipodType type, int candidate) {
  assert(ams[candidate] == null);

  var myType = type.index;
  var myDest = (myType + 1) * 2;
  for (int i = 0; i < ams.length; i++) {
    if (ams[i] != null) {
      var ocType = ams[i]!.type.index;
      var ocDest = (ocType + 1) * 2;

      if (isInBetween(candidate, i, ocDest) &&
          isInBetween(i, myDest, candidate)) return true;
    }
  }

  return false;
}

bool isInBetween(int toTest, int bound1, int bound2) =>
    min(bound1, bound2) < toTest && max(bound1, bound2) > toTest;

var bCount = 0;
Burrow? accessibleBurrows(GameState state, Amphipod amp) {
  Burrow? candidate = neighbourCheck(state, amp);
  if (candidate == null) return null;
  // return freePath(state, candidate, amp) ? candidate : null;
  if (freePath(state, candidate, amp)) {
    // bCount++;
    // if (bCount == 2000) {
    //   print('---HERE--');
    //   state.printMap();
    //   print(amp);
    //   print(candidate);
    //   throw Exception();
    // }
    return candidate;
  }

  return null;
}

Burrow? neighbourCheck(GameState state, Amphipod amp) {
  var options = burrowsPerType[amp.type]!;

  var burrows = state.burrows;
  for (var d = maxDepth; d >=0; d--) {
    var candidate = options[d];
    if (!burrows.containsKey(candidate)) return candidate;
    if (burrows[candidate]!.type != amp.type) return null;
  }
  
  return null;
}

bool freePath(GameState state, Burrow burrow, Amphipod amp) {
  for (int i = min(burrow.number, amp.hallway);
      i <= max(burrow.number, amp.hallway);
      i++) {
    if (i != amp.hallway && state.hallway[i] != null) return false;
  }

  return true;
}

class GameState implements Comparable<GameState> {
  Set<Amphipod> amps;
  List<Amphipod?> hallway;
  Map<Burrow, Amphipod> burrows;
  GameState(this.amps, this.hallway, this.burrows)
      : assert(amps.length == allAmphipods.length);

  bool get finished => amps.every((element) => element.finished);

  int get finishCount => amps.fold(0, (p, a) => p + (a.finished ? 1 : 0));

  GameState moveToBurrow(Amphipod amp, Burrow burrow) {
    assert(burrowsPerType[amp.type]!.contains(burrow));
    assert(!burrows.containsKey(burrow));
    var rAmps = Set.of(amps.where((element) => element != amp));
    var rHallway = List.of(hallway);
    var rBurrows = Map.of(burrows);

    var rAmp = Amphipod(amp.type, burrow: burrow, finished: true);
    rAmps.add(rAmp);
    rHallway[amp.hallway] = null;
    rBurrows[burrow] = rAmp;

    for (int i = burrow.deep + 1; i <= maxDepth; i++) {
      var bnb = Burrow(burrow.number, i);
      var under = burrows[bnb]!;
      if (!under.finished) {
        var rnb = under.finish();
        assert(rAmps.remove(under));
        rAmps.add(rnb);
        rBurrows[bnb] = rnb;
      }
    }

    return GameState(rAmps, rHallway, rBurrows);
  }

  GameState moveToHallway(Amphipod amp, int where) {
    assert(hallway[where] == null);
    var rAmps = Set.of(amps.where((element) => element != amp));
    var rHallway = List.of(hallway);
    var rBurrows = Map.of(burrows);

    var rAmp = Amphipod(amp.type, hallway: where);
    rAmps.add(rAmp);
    rHallway[where] = rAmp;
    rBurrows.remove(amp.burrow);

    return GameState(rAmps, rHallway, rBurrows);
  }

  int minCosts() {
    var result = 0;
    for (var am in amps) {
      var dest = (am.type.index + 1) * 2;
      if (am.hallway > -1) {
        var hallwayCosts = (am.hallway - dest).abs() + 1;
        result += hallwayCosts * am.energyCost;
      } else {
        var hallwayCosts = (am.burrow!.number - dest).abs();
        if (hallwayCosts > 0) {
          result += (hallwayCosts + am.burrow!.deep + 2) * am.energyCost;
        }
      }
    }

    return result;
  }

  @override
  int get hashCode => SetEquality().hash(amps);

  @override
  bool operator ==(other) =>
      other is GameState && SetEquality().equals(amps, other.amps);

  printMap() {
    print(hallway.map((e) => e == null ? '.' : e.type.toShortString()).join());
    for (int i = 0; i <= maxDepth; i++) {
      printBurrowLine(i);
    }
  }

  printBurrowLine(int deep) {
    print([
      '.',
      '.',
      ampInBurrow(Burrow(2, deep)),
      '.',
      ampInBurrow(Burrow(4, deep)),
      '.',
      ampInBurrow(Burrow(6, deep)),
      '.',
      ampInBurrow(Burrow(8, deep)),
      '.',
      '.',
    ].join());
  }

  String ampInBurrow(Burrow b) {
    if (burrows.containsKey(b)) {
      var amp = burrows[b]!;
      return amp.finished
          ? amp.type.toShortString().toUpperCase()
          : amp.type.toShortString();
    }

    return '.';
  }

  @override
  int compareTo(GameState other) => other.finishCount - finishCount;
}

enum AmphipodType { a, b, c, d }

extension ParseToString on AmphipodType {
  String toShortString() => toString().split('.').last;
}

const energyMap = {
  AmphipodType.a: 1,
  AmphipodType.b: 10,
  AmphipodType.c: 100,
  AmphipodType.d: 1000,
};

class Amphipod {
  final AmphipodType type;
  final Burrow? burrow;
  final int hallway;
  final bool finished;
  const Amphipod(
    this.type, {
    this.burrow,
    this.hallway = -1,
    this.finished = false,
  });

  int get energyCost => energyMap[type]!;

  Amphipod finish() => Amphipod(type, burrow: burrow, finished: true);

  @override
  int get hashCode =>
      type.hashCode +
      (burrow == null ? 0 : 31 * burrow.hashCode) +
      31 * hallway +
      31 * finished.hashCode;

  @override
  bool operator ==(other) =>
      other is Amphipod &&
      type == other.type &&
      burrow == other.burrow &&
      hallway == other.hallway &&
      finished == other.finished;

  @override
  String toString() => '$type[$hallway, $burrow, ${finished ? 'F' : '.'}]';
}

class Burrow {
  final int number;
  final int deep;
  const Burrow(this.number, this.deep)
      : assert((number == 2 || number == 4 || number == 6 || number == 8) &&
            (deep >= 0 && deep <= 3));

  @override
  int get hashCode => number + 7 * deep;

  @override
  bool operator ==(other) =>
      other is Burrow && number == other.number && deep == other.deep;

  @override
  String toString() => 'Burrow[$number,$deep]';
}
