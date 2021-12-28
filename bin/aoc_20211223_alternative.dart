void main() {
  var gs1 = GameState(20, 17, 16, 3, 21, 18, 5, 1, 19, 15, 14, 10, 13, 11, 7, 6);
  var gs2 = GameState(20, 17, 16, 3, 21, 18, 5, 3, 19, 15, 14, 10, 13, 11, 7, 6);
  print(gs1.hashCode);
  print(gs2.hashCode);
}

int choose(int n, int k) => (k == 0) ? 1 : (n * choose(n - 1, k - 1)) ~/ k;

class GameState {
  final int a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4;
  final int _hash;
  GameState(
    this.a1,
    this.a2,
    this.a3,
    this.a4,
    this.b1,
    this.b2,
    this.b3,
    this.b4,
    this.c1,
    this.c2,
    this.c3,
    this.c4,
    this.d1,
    this.d2,
    this.d3,
    this.d4,
  ) : _hash = _calcHash(
          a1,
          a2,
          a3,
          a4,
          b1,
          b2,
          b3,
          b4,
          c1,
          c2,
          c3,
          c4,
          d1,
          d2,
          d3,
          d4,
        );

  static int _calcHash(
    int a1,
    int a2,
    int a3,
    int a4,
    int b1,
    int b2,
    int b3,
    int b4,
    int c1,
    int c2,
    int c3,
    int c4,
    int d1,
    int d2,
    int d3,
    int d4,
  ) {
    return (_binomialCoefficientDist(a1, a2, a3, a4) << 42) +
        (_binomialCoefficientDist(b1, b2, b3, b4) << 28) +
        (_binomialCoefficientDist(c1, c2, c3, c4) << 14) +
        _binomialCoefficientDist(d1, d2, d3, d4);
  }

  static int _binomialCoefficientDist(int p1, int p2, int p3, int p4) =>
      _nChoose4[p1] + _nChoose3[p2] + _nChoose2[p3] + p4;

  @override
  int get hashCode => _hash;

  @override
  bool operator ==(other) => other is GameState && other._hash == _hash;

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
