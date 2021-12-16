import 'dart:math';

const data =
    '420D610055D273AF1630010092019207300B278BE5932551E703E608400C335003900AF0402905009923003880856201E95C00B60198D400B50034400E20101DC00E10024C00F1003C400B000212697140249D049F0F8952A8C6009780272D5D074B5741F3F37730056C0149658965E9AED7CA8401A5CC45BB801F0999FFFEEE0D67050C010C0036278A62D4D737F359993398027800BECFD8467E3109945C1008210C9C442690A6F719C48A351006E9359C1C5003E739087E80F27EC29A0030322BD2553983D272C67508E5C0804639D4BD004C401B8B918E3600021D1061D47A30053801C89EF2C4CCFF39204C53C212DABED04C015983A9766200ACE7F95C80D802B2F3499E5A700267838803029FC56203A009CE134C773A2D3005A77F4EDC6B401600043A35C56840200F4668A71580043D92D5A02535BAF7F9A89CF97C9F59A4F02C400C249A8CF1A49331004CDA00ACA46517E8732E8D2DB90F3005E92362194EF5E630CA5E5EEAD1803E200CC228E70700010A89D0BE3A08033146164177005A5AEEB1DA463BDC667600189C9F53A6FF6D6677954B27745CA00BCAE53A6EEDC60074C920001B93CFB05140289E8FA4812E071EE447218CBE1AA149008DBA00A497F9486262325FE521898BC9669B382015365715953C5FC01AA8002111721D4221007E13C448BA600B4F77F694CE6C01393519CE474D46009D802C00085C578A71E4001098F518639CC301802B400E7CDDF4B525C8E9CA2188032600E44B8F1094C0198CB16A29180351EA1DC3091F47A5CA0054C4234BDBC2F338A77B84F201232C01700042A0DC7A8A0200CC578B10A65A000601048B24B25C56995A30056C013927D927C91AB43005D127FDC610EF55273F76C96641002A4F0F8C01CCC579A8D68E52587F982996F537D600';

var totalVersion = 0;

void main(List<String> arguments) {
  var input = parseToBinary();
  var result = parseInput(input);

  print('Sum versions: $totalVersion');
  print('Calc result: ${result.value}');
}

ParsedData parseInput(String input) {
  var version = int.parse(input.substring(0, 3), radix: 2);
  var type = int.parse(input.substring(3, 6), radix: 2);

  totalVersion += version;

  input = input.substring(6);
  ParsedData p = (type == 4) ? parseLiteral(input) : parseOperator(input, type);

  return ParsedData(p.value, p.bitsConsumed + 6);
}

ParsedData parseOperator(String input, int type) {
  var lengthTypeId = input.substring(0, 1);

  var p = (lengthTypeId == '0')
      ? parseOperatorType0(input)
      : parseOperatorType1(input);

  return ParsedData(calcResult(p.values, type), p.bitsConsumed);
}

ParsedOperator parseOperatorType0(String input) {
  var sub = input.substring(1, 16);
  var subPackLength = int.parse(sub, radix: 2);

  var values = <int>[];
  input = input.substring(16);
  var consumed = 0;
  while (consumed < subPackLength) {
    var p = parseInput(input);
    values.add(p.value);
    consumed += p.bitsConsumed;
    input = input.substring(p.bitsConsumed);
  }

  return ParsedOperator(values, 16 + consumed);
}

ParsedOperator parseOperatorType1(String input) {
  var values = <int>[];
  var subPackCount = int.parse(input.substring(1, 12), radix: 2);
  input = input.substring(12);
  var consumed = 12;
  for (int i = 0; i < subPackCount; i++) {
    var p = parseInput(input);
    values.add(p.value);
    input = input.substring(p.bitsConsumed);
    consumed += p.bitsConsumed;
  }

  return ParsedOperator(values, consumed);
}

ParsedData parseLiteral(String input) {
  var index = 0;
  var bin = '';
  bool ongoing = true;
  while (ongoing) {
    ongoing = input.substring(index, index + 1) == '1';
    bin += input.substring(index + 1, index + 5);
    index += 5;
  }

  return ParsedData(int.parse(bin, radix: 2), index);
}

int calcResult(List<int> values, int type) {
  if (type == 0) return values.reduce((a, b) => a + b);
  if (type == 1) return values.fold(1, (a, b) => a * b);
  if (type == 2) return values.reduce(min);
  if (type == 3) return values.reduce(max);
  if (type == 5) return values[0] > values[1] ? 1 : 0;
  if (type == 6) return values[0] < values[1] ? 1 : 0;
  if (type == 7) return values[0] == values[1] ? 1 : 0;

  throw Exception('invalid type: $type');
}

class ParsedData {
  final int value;
  final int bitsConsumed;
  ParsedData(this.value, this.bitsConsumed);

  @override
  String toString() => 'value=$value bitsConsumed=$bitsConsumed';
}

class ParsedOperator {
  final List<int> values;
  final int bitsConsumed;
  ParsedOperator(this.values, this.bitsConsumed);
}

String parseToBinary() {
  var total = BigInt.from(0);
  var base = BigInt.from(16);
  for (var i = data.length - 1; i >= 0; i--) {
    var hexCharacter = data.substring(i, i + 1);
    var value = int.parse(hexCharacter, radix: 16);
    var bigIntValue = BigInt.from(value);
    var powered = base.pow(data.length - 1 - i);
    var plus = bigIntValue * powered;
    total += plus;
  }

  var result = total.toRadixString(2);
  var rest = result.length % 4;
  var times = rest == 0 ? 0 : 4 - rest;
  return '0' * times + result;
}
