void main() {
  // var s1 = GameState(
  //   cave: [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4],
  //   canLeaveRoom: [7, 11, 15, 19],
  //   freeRoom: [-1, -1, -1, -1],
  // );

  // printCave(s1);

  var s2 = GameState(
    cave: [0, 0, 0, 0, 0, 4, 1, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 0, 4, 4, 4],
    canLeaveRoom: [-1, 11, 15, -1],
    freeRoom: [0, -1, -1, 0],
  );

  var nodes = fromHallWay(s2);
  print(nodes.first.costs);

  var n2 = fromHallWay(nodes.first.state);
  print(n2.first.state.cave);
}

Set<GameState> moves(GameState gs) {
  var result = <GameState>{};

  // result.addAll(fromRoom(gs));
  // result.addAll(fromHallWay(gs));

  return result;
}

Set<Node> fromHallWay(GameState gs) {
  var result = <Node>{};

  for (int i = 0; i <= 6; i++) {
    var amp = gs.cave[i] - 1;
    if (amp >= 0) {
      var route = hallwayToRoom[amp][i];
      if (gs.freeRoom[amp] > -1 && isRouteFree(gs, route)) {
        var costs = (route.length + gs.freeRoom[amp] + 1) * moveCosts[amp];

        var cave = [...gs.cave];
        cave[i] = 0;
        cave[roomEntrances[amp] + gs.freeRoom[amp]] = amp + 1;
        var freeRoom = [...gs.freeRoom];
        freeRoom[amp]--;
        result.add(
          Node(
            GameState(
              cave: cave,
              freeRoom: freeRoom,
              canLeaveRoom: gs.canLeaveRoom,
            ),
            costs,
          ),
        );
      }
    }
  }

  return result;
}

bool isRouteFree(GameState gs, Route route) {
  for (var position in route.positions) {
    if (gs.cave[position] != 0) return false;
  }

  return true;
}

Set<Node> fromRoom(GameState gs) {
  var result = <Node>{};

  for (var leaver in gs.canLeaveRoom) {
    if (leaver > -1) {
      var amp = gs.cave[leaver];
    }
  }

  return result;
}

void printCave(GameState gs) {
  const chars = ['.', 'A', 'B', 'C', 'D'];
  String hallway = '';
  for (int i = 0; i < 7; i++) {
    hallway += chars[gs.cave[i]];
    if (i >= 3 && i <= 6) hallway += '.';
  }
  print(hallway);
  for (var b = 0; b < 4; b++) {
    print('  ' +
        chars[gs.cave[roomEntrances[0] + b]] +
        ' ' +
        chars[gs.cave[roomEntrances[1] + b]] +
        ' ' +
        chars[gs.cave[roomEntrances[2] + b]] +
        ' ' +
        chars[gs.cave[roomEntrances[3] + b]]);
  }
}

class Node {
  final GameState state;
  final int costs;
  Node(this.state, this.costs);
}

class Route {
  final List<int> positions;
  final int length;
  const Route(this.positions, this.length);
}

class GameState {
  final List<int> cave;
  final List<int> canLeaveRoom;
  final List<int> freeRoom;
  final int _hash;

  GameState({
    required this.cave,
    required this.canLeaveRoom,
    required this.freeRoom,
  }) : _hash = _calcHash(cave);

  static int _calcHash(cave) {
    assert(cave.length == 23);
    var aa = [0, 0, 0, 0];
    var bb = [0, 0, 0, 0];
    var cc = [0, 0, 0, 0];
    var dd = [0, 0, 0, 0];
    var ai = 0, bi = 0, ci = 0, di = 0;

    for (int i = 22; i >= 0; i--) {
      if (cave[i] == 1) aa[ai++] = i;
      if (cave[i] == 2) bb[bi++] = i;
      if (cave[i] == 3) cc[ci++] = i;
      if (cave[i] == 4) dd[di++] = i;
    }
    assert(ai == 4 && bi == 4 && ci == 4 && di == 4);

    return (_enumeratedDistribution(aa) << 42) +
        (_enumeratedDistribution(bb) << 28) +
        (_enumeratedDistribution(cc) << 14) +
        _enumeratedDistribution(dd);
  }

  // max value is 8854, which fits in a 14 bits binary number
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
