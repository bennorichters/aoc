import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  magnitudeAll(lines);
  largestMagnitude(lines);
}

void largestMagnitude(List<String> lines) {
  var result = 0;

  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines.length; j++) {
      if (i != j) {
        var sum = parseLine(lines[i]) + parseLine(lines[j]);
        reduce(sum);
        var mag = magnitude(sum);

        result = max(result, mag);
      }
    }
  }

  print('max magnitude: $result');
}

void magnitudeAll(List<String> lines) {
  var root = parse(lines[0]) as Pair;
  for (int i = 1; i < lines.length; i++) {
    root += parseLine(lines[i]);
    reduce(root);
  }

  print('root sum all: $root');
  print('magnitude sum all: ${magnitude(root)}');
}

int magnitude(Pair p) {
  var leftValue =
      (p.left is Number) ? (p.left as Number).value : magnitude(p.left as Pair);

  var rightValue = (p.right is Number)
      ? (p.right as Number).value
      : magnitude(p.right as Pair);

  return 3 * leftValue + 2 * rightValue;
}

void reduce(Pair root) {
  while (true) {
    var n = findPairToExplode(root);
    if (n != null) {
      explode(n);
      continue;
    }

    var s = findNumberToSplit(root);
    if (s != null) {
      split(s);
      continue;
    }

    break;
  }
}

Number? findNumberToSplit(Element e) {
  if (e is Number) return e.value > 9 ? e : null;

  var p = e as Pair;
  var findLeft = findNumberToSplit(p.left);
  if (findLeft != null) return findLeft;
  return findNumberToSplit(p.right);
}

void split(Number nr) {
  var left = Number(nr.value ~/ 2);
  var right = Number((nr.value ~/ 2) + (nr.value % 2));

  var replacer = Pair(left, right);
  left.parent = replacer;
  right.parent = replacer;

  replaceParent(nr, replacer);
}

Pair? findPairToExplode(Element e, [int level = 0]) {
  if (e is Number) return null;
  if (level == 4) return (e as Pair);

  var p = e as Pair;
  var n = findPairToExplode(p.left, level + 1);
  if (n != null) return n;

  return findPairToExplode(p.right, level + 1);
}

void explode(Pair p) {
  var nrLeft = findNeighbourNumber(p, Side.left);
  var nrRight = findNeighbourNumber(p, Side.right);

  if (nrLeft != null) nrLeft.value += (p.left as Number).value;
  if (nrRight != null) nrRight.value += (p.right as Number).value;

  replaceParent(p, Number(0));
}

void replaceParent(Element old, Element replacer) {
  replacer.parent = old.parent;
  if (old.parent!.left == old) {
    old.parent!.left = replacer;
  } else {
    old.parent!.right = replacer;
  }
  old.parent = null;
}

enum Side { left, right }
typedef LeftOrRight = Element Function(Pair p);

Number? findNeighbourNumber(Pair p, Side s) {
  LeftOrRight lor = s == Side.left ? (p) => p.left : (p) => p.right;
  LeftOrRight rol = s == Side.left ? (p) => p.right : (p) => p.left;

  Number? process() {
    if (p.parent == null) return null;
    if (lor(p.parent!) == p) return findNeighbourNumber(p.parent!, s);
    if (lor(p.parent!) is Number) return lor(p.parent!) as Number;

    return mostOuterNumber(lor(p.parent!) as Pair, rol);
  }

  return process();
}

Number? mostOuterNumber(Pair p, LeftOrRight lor) {
  if (lor(p) is Number) return lor(p) as Number;
  return mostOuterNumber(lor(p) as Pair, lor);
}

Pair parseLine(String input) => parse(input) as Pair;

Element parse(String input) {
  if (isNumeric(input)) return Number(int.parse(input));

  var c = findComma(input);
  var left = parse(input.substring(1, c));
  var right = parse(input.substring(c + 1, input.length - 1));

  var result = Pair(left, right);
  left.parent = result;
  right.parent = result;

  return result;
}

int findComma(String input) {
  var open = 0;
  for (int i = 1; i < input.length - 2; i++) {
    var char = input.substring(i, i + 1);
    if (char == '[') open++;
    if (char == ']') open--;
    if (open == 0 && char == ',') return i;
  }

  throw Exception('cannot find comma: $input');
}

bool isNumeric(String str) => RegExp(r'^-?[0-9]+$').hasMatch(str);

class Element {
  Pair? parent;
}

class Number extends Element {
  int value;
  Number(this.value);

  @override
  String toString() => '$value';
}

class Pair extends Element {
  Element left;
  Element right;
  Pair(this.left, this.right);

  Pair operator +(Pair other) {
    var result = Pair(this, other);
    parent = result;
    other.parent = result;

    return result;
  }

  @override
  String toString() => '[$left,$right]';
}
