import 'dart:io';

void main(List<String> arguments) {
  // var lines = File('./tin').readAsLinesSync();
  var lines = File('./in').readAsLinesSync();

  var moves = lines[0].split(',').map((e) => int.parse(e));

  List<List<List<int>>> boards = [];
  for (int i = 2; i < lines.length;) {
    List<List<int>> board = [];
    for (int j = 0; j < 5; j++) {
      var line = lines[i].trim().split(RegExp('\\s+'));
      var row = line.map((e) => int.parse(e));
      board.add(List.of(row));
      i++;
    }
    boards.add(board);
    i++;
  }

  var marks = List.generate(
      boards.length, (i) => List.generate(5, (i) => List.filled(5, false)));

  var status = List.filled(boards.length, false);

  for (var move in moves) {
    for (int i = 0; i < boards.length; i++) {
      markNr(move, boards[i], marks[i]);
      status[i] = wins(marks[i]);
      if (status.every((element) => element)) {
        print(status);
        print(move);
        print(i);
        print(move * sumUnmarked(boards[i], marks[i]));
        exit(0);
      }
    }
  }
}

bool wins(List<List<bool>> board) {
  for (int i = 0; i < board.length; i++) {
    if (board[i].every((e) => e)) return true;
  }

  for (int i = 0; i < 5; i++) {
    var col = true;
    for (int j = 0; j < 5; j++) {
      col = col & board[j][i];
    }
    if (col) return true;
  }

  return false;
}

int sumUnmarked(List<List<int>> board, List<List<bool>> marks) {
  var result = 0;
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      if (!marks[i][j]) result += board[i][j];
    }
  }
  return result;
}

void markNr(int nr, List<List<int>> board, List<List<bool>> mark) {
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      mark[i][j] = mark[i][j] || (board[i][j] == nr);
    }
  }
}
