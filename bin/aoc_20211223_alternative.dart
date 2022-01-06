import 'package:collection/collection.dart';

void main() {
  var endState = GameState(
    cave: [
      -1, -1, -1, -1, -1, -1, -1, // hallway
      0, 0, 0, 0, // room A
      1, 1, 1, 1, // room B
      2, 2, 2, 2, // room C
      3, 3, 3, 3, // room D
    ],
    vacatableRooms: [-1, -1, -1, -1],
    accessibleRooms: [-1, -1, -1, -1],
  );

  // var puzzle = GameState(
  //   cave: [
  //     -1, -1, -1, -1, -1, -1, -1, // hallway
  //     1, 3, 3, 0, // room A
  //     2, 2, 1, 3, // room B
  //     1, 1, 0, 2, // room C
  //     3, 0, 2, 0, // room D
  //   ],
  //   vacatableRooms: [0, 0, 0, 0],
  //   accessibleRooms: [-1, -1, -1, -1],
  // );

  var puzzle = GameState(
    cave: [
      -1, -1, -1, -1, -1, -1, -1, // hallway
      2, 3, 3, 1, // room A
      0, 2, 1, 0, // room B
      1, 1, 0, 3, // room C
      3, 0, 2, 2, // room D
    ],
    vacatableRooms: [0, 0, 0, 0],
    accessibleRooms: [-1, -1, -1, -1],
  );

  var result = -1;
  var visited = <GameState, int>{};
  var queue = PriorityQueue<QueueElement>()..add(QueueElement(puzzle, 0));
  while (queue.isNotEmpty) {
    var node = queue.removeFirst();
    if (result > -1 && node.costs >= result) break;
    if (visited.containsKey(node.state) && visited[node.state]! <= node.costs) {
      continue;
    }

    if (node.state == endState) {
      result = node.costs;
      continue;
    }

    visited[node.state] = node.costs;
    queue.addAll(moves(node));
  }

  print(result);
}

Set<QueueElement> moves(QueueElement node) {
  var result = <QueueElement>{};

  result.addAll(fromRoomToRoom(node));
  if (result.isEmpty) {
    result.addAll(fromHallWayToRoom(node));
    if (result.isEmpty) {
      result.addAll(fromRoomToHallway(node));
    }
  }

  return result;
}

Set<QueueElement> fromRoomToRoom(QueueElement element) {
  var result = <QueueElement>{};

  var gs = element.state;
  var costs = element.costs;

  for (var leaver in roomLeavers(gs)) {
    var route = roomToRoom[leaver.roomSection][leaver.amp];
    var roomToOccupie = gs.accessibleRooms[leaver.amp];
    if (roomToOccupie > -1 && isRouteFree(gs, route.positions)) {
      var rCosts = costs +
          (route.length + leaver.room + roomToOccupie + 1) *
              moveCosts[leaver.amp];

      var rgs = afterLeavingRoom(
        gs,
        leaver,
        roomEntrances[leaver.amp] + roomToOccupie
      );
      rgs.accessibleRooms[leaver.amp]--;

      result.add(QueueElement(rgs, rCosts));
    }
  }

  return result;
}

Set<QueueElement> fromRoomToHallway(QueueElement element) {
  var result = <QueueElement>{};

  var gs = element.state;
  var costs = element.costs;

  for (var leaver in roomLeavers(gs)) {
    var options = allowedHallway[leaver.amp][leaver.roomSection];
    for (var candidate in options) {
      var route = hallwayToRoom[leaver.roomSection][candidate];
      if (gs.cave[candidate] == -1 && isRouteFree(gs, route.positions)) {
        var rCosts =
            costs + (route.length + leaver.room + 1) * moveCosts[leaver.amp];

        result.add(
          QueueElement(
            afterLeavingRoom(
              gs,
              leaver,
              candidate,
            ),
            rCosts,
          ),
        );
      }
    }
  }

  return result;
}

GameState afterLeavingRoom(GameState gs, RoomLeaver leaver, int toOccupie) {
  var cave = [...gs.cave];
  cave[leaver.room + roomEntrances[leaver.roomSection]] = -1;
  cave[toOccupie] = leaver.amp;

  var accessibleRooms = [...gs.accessibleRooms];
  var vacatableRooms = [...gs.vacatableRooms];
  if (isSectionAccessible(cave, leaver.roomSection, leaver.room)) {
    accessibleRooms[leaver.roomSection] = leaver.room;
    vacatableRooms[leaver.roomSection] = -1;
  } else if (leaver.room == 3) {
    vacatableRooms[leaver.roomSection] = -1;
  } else {
    vacatableRooms[leaver.roomSection]++;
  }

  return GameState(
    cave: cave,
    accessibleRooms: accessibleRooms,
    vacatableRooms: vacatableRooms,
  );
}

class RoomLeaver {
  final int roomSection;
  final int room;
  final int amp;
  RoomLeaver(this.roomSection, this.room, this.amp);
}

Iterable<RoomLeaver> roomLeavers(GameState gs) {
  var result = <RoomLeaver>{};

  for (int roomSection = 0; roomSection < 4; roomSection++) {
    var roomToVacate = gs.vacatableRooms[roomSection];
    if (roomToVacate > -1) {
      var amp = gs.cave[roomToVacate + roomEntrances[roomSection]];
      result.add(RoomLeaver(roomSection, roomToVacate, amp));
    }
  }

  return result;
}

bool isSectionAccessible(List<int> cave, int section, int vacatedRoom) {
  for (var roomTest = vacatedRoom + 1; roomTest < 4; roomTest++) {
    if (cave[roomEntrances[section] + roomTest] != section) return false;
  }

  return true;
}

Set<QueueElement> fromHallWayToRoom(QueueElement element) {
  var result = <QueueElement>{};

  var gs = element.state;
  var costs = element.costs;

  for (int hallwayPos = 0; hallwayPos <= 6; hallwayPos++) {
    var amp = gs.cave[hallwayPos];
    if (amp >= 0) {
      var route = hallwayToRoom[amp][hallwayPos];
      if (gs.accessibleRooms[amp] > -1 && isRouteFree(gs, route.positions)) {
        var rCosts = costs +
            (route.length + gs.accessibleRooms[amp] + 1) * moveCosts[amp];

        var cave = [...gs.cave];
        cave[hallwayPos] = -1;
        cave[roomEntrances[amp] + gs.accessibleRooms[amp]] = amp;
        var accessibleRooms = [...gs.accessibleRooms];
        accessibleRooms[amp]--;

        result.add(
          QueueElement(
            GameState(
              cave: cave,
              accessibleRooms: accessibleRooms,
              vacatableRooms: gs.vacatableRooms,
            ),
            rCosts,
          ),
        );
      }
    }
  }

  return result;
}

bool isRouteFree(GameState gs, List<int> positions) {
  for (var position in positions) {
    if (gs.cave[position] != -1) return false;
  }

  return true;
}

void printCave(List<int> cave) {
  const chars = ['.', 'A', 'B', 'C', 'D'];
  String hallway = '';
  for (int i = 0; i < 7; i++) {
    hallway += chars[cave[i] + 1];
    if (i >= 1 && i <= 4) hallway += '.';
  }
  print(hallway);
  for (var b = 0; b < 4; b++) {
    print(
      '  ' +
          chars[cave[roomEntrances[0] + b] + 1] +
          ' ' +
          chars[cave[roomEntrances[1] + b] + 1] +
          ' ' +
          chars[cave[roomEntrances[2] + b] + 1] +
          ' ' +
          chars[cave[roomEntrances[3] + b] + 1],
    );
  }
}

class QueueElement implements Comparable<QueueElement> {
  final GameState state;
  final int costs;
  QueueElement(this.state, this.costs);

  @override
  int compareTo(QueueElement other) {
    return costs - other.costs;
  }
}

class Route {
  final List<int> positions;
  final int length;
  const Route(this.positions, this.length);
}

class GameState {
  final List<int> cave;
  final List<int> vacatableRooms;
  final List<int> accessibleRooms;
  final int _hash;

  GameState({
    required this.cave,
    required this.vacatableRooms,
    required this.accessibleRooms,
  }) : _hash = _calcHash(cave);

  static int _calcHash(cave) {
    var aa = [0, 0, 0, 0];
    var bb = [0, 0, 0, 0];
    var cc = [0, 0, 0, 0];
    var dd = [0, 0, 0, 0];
    var ai = 0, bi = 0, ci = 0, di = 0;

    for (int i = 22; i >= 0; i--) {
      if (cave[i] == 0) aa[ai++] = i;
      if (cave[i] == 1) bb[bi++] = i;
      if (cave[i] == 2) cc[ci++] = i;
      if (cave[i] == 3) dd[di++] = i;
    }
    assert(ai == 4 && bi == 4 && ci == 4 && di == 4, '$cave');

    return (_enumeratedDistribution(aa) << 42) +
        (_enumeratedDistribution(bb) << 28) +
        (_enumeratedDistribution(cc) << 14) +
        _enumeratedDistribution(dd);
  }

  // max value is 8854, which fits in 14 bits
  static int _enumeratedDistribution(List<int> nrs) =>
      _nChoose4[nrs[0]] + _nChoose3[nrs[1]] + _nChoose2[nrs[2]] + nrs[3];

  // https://en.wikipedia.org/wiki/Hash_function#Identity_hash_function
  @override
  int get hashCode => _hash;

  @override
  bool operator ==(other) => other is GameState && other._hash == _hash;

  // for example: _nChoose2[10] has the value: 10 choose 2 (=45)
  static const _nChoose2 = [
    0,
    0,
    1,
    3,
    6,
    10,
    15,
    21,
    28,
    36,
    45,
    55,
    66,
    78,
    91,
    105,
    120,
    136,
    153,
    171,
    190,
    210,
    231,
    253
  ];

  static const _nChoose3 = [
    0,
    0,
    0,
    1,
    4,
    10,
    20,
    35,
    56,
    84,
    120,
    165,
    220,
    286,
    364,
    455,
    560,
    680,
    816,
    969,
    1140,
    1330,
    1540,
    1771
  ];

  static const _nChoose4 = [
    0,
    0,
    0,
    0,
    1,
    5,
    15,
    35,
    70,
    126,
    210,
    330,
    495,
    715,
    1001,
    1365,
    1820,
    2380,
    3060,
    3876,
    4845,
    5985,
    7315,
    8855
  ];
}

const hallwayToRoom = [
  [
    // A
    Route([1], 2),
    Route([], 1),
    Route([], 1),
    Route([2], 3),
    Route([3, 2], 5),
    Route([4, 3, 2], 7),
    Route([5, 4, 3, 2], 8),
  ],
  [
    // B
    Route([1, 2], 4),
    Route([2], 3),
    Route([], 1),
    Route([], 1),
    Route([3], 3),
    Route([4, 3], 5),
    Route([5, 4, 3], 6),
  ],
  [
    // C
    Route([1, 2, 3], 6),
    Route([2, 3], 5),
    Route([3], 3),
    Route([], 1),
    Route([], 1),
    Route([4], 3),
    Route([5, 4], 4),
  ],
  [
    // D
    Route([1, 2, 3, 4], 8),
    Route([2, 3, 4], 7),
    Route([3, 4], 5),
    Route([4], 3),
    Route([], 1),
    Route([], 1),
    Route([5], 2),
  ],
];

const roomEntrances = [7, 11, 15, 19];

const moveCosts = [1, 10, 100, 1000];

const allowedHallway = [
  // Amphipod A
  [
    [0, 1, 2, 3, 4, 5, 6], // Leaving room A
    [0, 1, 3, 4, 5, 6], // Leaving room B
    [0, 1, 4, 5, 6], // Leaving room C
    [0, 1, 5, 6], // Leaving room D
  ],
  // Amphipod B
  [
    [0, 1, 3, 4, 5, 6], // Leaving room A
    [0, 1, 2, 3, 4, 5, 6], // ...
    [0, 1, 2, 4, 5, 6],
    [0, 1, 2, 5, 6],
  ],
  // Amphipod C
  [
    [0, 1, 4, 5, 6],
    [0, 1, 2, 4, 5, 6],
    [0, 1, 2, 3, 4, 5, 6],
    [0, 1, 2, 3, 5, 6],
  ],
  // Amphipod D
  [
    [0, 1, 5, 6],
    [0, 1, 2, 5, 6],
    [0, 1, 2, 3, 5, 6],
    [0, 1, 2, 3, 4, 5, 6],
  ],
];

const roomToRoom = [
  [
    // From room A
    Route([], -1), // to room A
    Route([2], 3), // to room B
    Route([2, 3], 5), // to room C
    Route([2, 3, 4], 7), // to room D
  ],
  [
    // From room B
    Route([2], 3), // to toom A
    Route([], -1), // ...
    Route([3], 3),
    Route([3, 4], 5),
  ],
  [
    // From room C
    Route([2, 3], 5),
    Route([3], 3),
    Route([], -1),
    Route([4], 3),
  ],
  [
    // From room D
    Route([2, 3, 4], 7),
    Route([3, 4], 5),
    Route([4], 3), // ...
    Route([], -1), // to room D
  ],
];
