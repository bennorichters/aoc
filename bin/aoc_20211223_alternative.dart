void main() {
  var s1 = GameState(
      [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4]);
  var s2 = GameState(
      [1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4]);

  printCave(s1);
  print('');
  printCave(s2);
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
        chars[gs.cave[7 + b]] +
        ' ' +
        chars[gs.cave[11 + b]] +
        ' ' +
        chars[gs.cave[15 + b]] +
        ' ' +
        chars[gs.cave[19 + b]]);
  }
}

class GameState {
  final List<int> cave;
  final int _hash;
  GameState(this.cave) : _hash = _calcHash(cave);

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
