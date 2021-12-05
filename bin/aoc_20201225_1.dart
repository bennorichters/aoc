void main(List<String> arguments) {
  // const pkCard = 5764801;
  // const pkDoor = 17807724;
  const pkCard = 18499292;
  const pkDoor = 8790390;

  const prime = 20201227;

  int step(int val, int subject) => (val * subject) % prime;

  int findLoopSize(int publicKey) {
    const subject = 7;
    var val = 1;
    var result = 0;
    while (val != publicKey) {
      result++;
      val = step(val, subject);
    }

    return result;
  }

  int calcKey(int loopSize, int subject) {
    var result = 1;
    for (var i = 0; i < loopSize; i++) {
      result = step(result, subject);
    }

    return result;
  }

  var lsCard = findLoopSize(pkCard);
  var lsDoor = findLoopSize(pkDoor);
  print(calcKey(lsCard, pkDoor));
  print(calcKey(lsDoor, pkCard));
}
