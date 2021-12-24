import 'dart:io';

void main() {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  //         1  2  3  4  5  6  7  8  9 10 11 12 13 14
  var nrs = [2, 1, 1, 9, 1, 8, 6, 1, 1, 5, 1, 1, 6, 1];
  // var nrs = [9, 4, 9, 9, 2, 9, 9, 4, 1, 9, 5, 9, 9, 8];
  var alu = Alu(nrs);

  List<Operation> ops = [];
  for (var line in lines) {
    ops.add(parseLine(line));
  }

  for (var op in ops) {
    // for (var i = 0; i < 14 * 18; i++) {
    // var op = ops[i];
    op.execute(alu);
  }

  print(alu);

  print(alu.z.toRadixString(26));

  // for (int i = 0; i < lines.length; i += 18) {
  //   print('${lines[i + 4]} -- remove:${lines[i + 5]} -- add:${lines[i + 15]}');
  // }
}

Operation parseLine(String line) {
  var parts = line.split(' ');
  if (parts[0] == 'inp') {
    return InputOperation(parseVariable(parts[1]));
  } else {
    Calculator calc = parseMethod(parts[0]);
    Variable left = parseVariable(parts[1]);

    if (const ['w', 'x', 'y', 'z'].contains(parts[2])) {
      return CalcOperation(calc, left, parseVariable(parts[2]), null);
    } else {
      return CalcOperation(calc, left, null, int.parse(parts[2]));
    }
  }
}

abstract class Operation {
  void execute(Alu alu);
}

class InputOperation extends Operation {
  final Variable variable;
  InputOperation(this.variable);

  @override
  void execute(Alu alu) => alu.inp(variable);
}

class CalcOperation extends Operation {
  final Calculator calc;
  final Variable store;
  final Variable? otherVar;
  final int? otherInt;
  CalcOperation(this.calc, this.store, this.otherVar, this.otherInt);

  @override
  void execute(Alu alu) => alu.operation(
        calc,
        store,
        otherVar: otherVar,
        otherInt: otherInt,
      );
}

Calculator parseMethod(String txt) {
  switch (txt) {
    case 'add':
      return (a, b) => a + b;
    case 'div':
      return (a, b) {
        if (b == 0) throw Exception('/0');
        return a ~/ b;
      };
    case 'eql':
      return (a, b) => (a == b) ? 1 : 0;
    case 'mod':
      return (a, b) {
        if (a < 0 || b <= 0) throw Exception('invalid values for mod: $a, $b');
        return a % b;
      };
    case 'mul':
      return (a, b) => a * b;
  }

  throw Exception('unsupported operation: $txt');
}

Variable parseVariable(String txt) {
  switch (txt) {
    case 'w':
      return Variable.w;
    case 'x':
      return Variable.x;
    case 'y':
      return Variable.y;
    case 'z':
      return Variable.z;
  }

  throw Exception('unsupported variable: $txt');
}

enum Variable { w, x, y, z }

typedef Calculator = int Function(int left, int right);

class Alu {
  final List<int> input;
  int index = 0;
  int w = 0, x = 0, y = 0, z = 0;

  Alu(this.input);

  void inp(Variable v) {
    var value = input[index++];
    _setValue(v, value);
  }

  void operation(
    Calculator calc,
    Variable v, {
    Variable? otherVar,
    int? otherInt,
  }) {
    var left = _readValue(v);
    var right = otherVar == null ? otherInt : _readValue(otherVar);
    _setValue(v, calc(left, right!));
  }

  int _readValue(Variable v) {
    switch (v) {
      case Variable.w:
        return w;
      case Variable.x:
        return x;
      case Variable.y:
        return y;
      case Variable.z:
        return z;
    }
  }

  void _setValue(Variable v, int value) {
    switch (v) {
      case Variable.w:
        {
          w = value;
          break;
        }
      case Variable.x:
        {
          x = value;
          break;
        }
      case Variable.y:
        {
          y = value;
          break;
        }
      case Variable.z:
        {
          z = value;
          break;
        }
    }
  }

  @override
  String toString() => 'w:$w, x:$x, y:$y, z:$z';
}
