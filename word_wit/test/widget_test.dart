// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:word_wit/model.dart' as game;

void main() {
  testGame(["shore", "steak", "steel", "steal", "stare"]);
}

void testGame(List<String> dictionary) {
  var testWord = "steel";
  var guesses = ["shore", "steak", "steel"];
  var testIO = TestIO(guesses);
  var testGame = game.Game(testWord, guesses.length, testIO, dictionary);
  testIO.currectGame = testGame;
  //test basic functions
  test('checkLetter_contained', () {
    game.Letter testLetter = testGame.checkLetter('l', 0);
    expect(testLetter.status, game.LetterStatus.contained);
  });
  test('checkLetter_absent', () {
    game.Letter testLetter = testGame.checkLetter('a', 1);
    expect(testLetter.status, game.LetterStatus.absent);
  });
  test('checkLetter_correct', () {
    game.Letter testLetter = testGame.checkLetter('e', 3);
    expect(testLetter.status, game.LetterStatus.correct);
  });

  test('checkWord_correct', () {
    var letters = testGame.checkWord([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("e", game.LetterStatus.unguessed, 3),
      game.Letter("l", game.LetterStatus.unguessed, 4),
    ]);
    expect(letters[0].letter, 's');
    expect(letters[0].status, game.LetterStatus.correct);
    expect(letters[0].index, 0);

    expect(letters[1].letter, 't');
    expect(letters[1].status, game.LetterStatus.correct);
    expect(letters[1].index, 1);

    expect(letters[2].letter, 'e');
    expect(letters[2].status, game.LetterStatus.correct);
    expect(letters[2].index, 2);

    expect(letters[3].letter, 'e');
    expect(letters[3].status, game.LetterStatus.correct);
    expect(letters[3].index, 3);

    expect(letters[4].letter, 'l');
    expect(letters[4].status, game.LetterStatus.correct);
    expect(letters[4].index, 4);
  });

  test('checkWord_incorrect', () {
    var letters = testGame.checkWord([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("a", game.LetterStatus.unguessed, 3),
      game.Letter("k", game.LetterStatus.unguessed, 4),
    ]);
    expect(letters[0].letter, 's');
    expect(letters[0].status, game.LetterStatus.correct);
    expect(letters[0].index, 0);

    expect(letters[1].letter, 't');
    expect(letters[1].status, game.LetterStatus.correct);
    expect(letters[1].index, 1);

    expect(letters[2].letter, 'e');
    expect(letters[2].status, game.LetterStatus.correct);
    expect(letters[2].index, 2);

    expect(letters[3].letter, 'a');
    expect(letters[3].status, game.LetterStatus.absent);
    expect(letters[3].index, 3);

    expect(letters[4].letter, 'k');
    expect(letters[4].status, game.LetterStatus.absent);
    expect(letters[4].index, 4);
  });

  test('checkWord_duplicate', () {
    var letters = testGame.checkWord([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("a", game.LetterStatus.unguessed, 2),
      game.Letter("l", game.LetterStatus.unguessed, 3),
      game.Letter("l", game.LetterStatus.unguessed, 4),
    ]);
    expect(letters[0].letter, 's');
    expect(letters[0].status, game.LetterStatus.correct);
    expect(letters[0].index, 0);

    expect(letters[1].letter, 't');
    expect(letters[1].status, game.LetterStatus.correct);
    expect(letters[1].index, 1);

    expect(letters[2].letter, 'a');
    expect(letters[2].status, game.LetterStatus.absent);
    expect(letters[2].index, 2);

    expect(letters[3].letter, 'l');
    expect(letters[3].status, game.LetterStatus.absent);
    expect(letters[3].index, 3);

    expect(letters[4].letter, 'l');
    expect(letters[4].status, game.LetterStatus.correct);
    expect(letters[4].index, 4);
  });

  test('checkDuplicate', () {
    var guessLetters = [
      game.Letter('s', game.LetterStatus.correct, 0),
      game.Letter('t', game.LetterStatus.correct, 1),
      game.Letter('a', game.LetterStatus.absent, 2),
      game.Letter('l', game.LetterStatus.contained, 3),
      game.Letter('l', game.LetterStatus.correct, 4),
    ];
    var result = testGame.checkDuplicate(guessLetters);
    expect(result[0].letter, 's');
    expect(result[0].status, game.LetterStatus.correct);
    expect(result[0].index, 0);

    expect(result[1].letter, 't');
    expect(result[1].status, game.LetterStatus.correct);
    expect(result[1].index, 1);

    expect(result[2].letter, 'a');
    expect(result[2].status, game.LetterStatus.absent);
    expect(result[2].index, 2);

    expect(result[3].letter, 'l');
    expect(result[3].status, game.LetterStatus.absent);
    expect(result[3].index, 3);

    expect(result[4].letter, 'l');
    expect(result[4].status, game.LetterStatus.correct);
    expect(result[4].index, 4);
  });

  test('addGuessedLetter', () {
    testGame.guessedLetters = [];
    testGame.addGuessedLetter(game.Letter('s', game.LetterStatus.correct, 0));
    expect(testGame.guessedLetters[0].letter, 's');
    expect(testGame.guessedLetters[0].status, game.LetterStatus.correct);
    expect(testGame.guessedLetters[0].index, 0);

    testGame.addGuessedLetter(game.Letter('t', game.LetterStatus.correct, 1));
    expect(testGame.guessedLetters[1].letter, 't');
    expect(testGame.guessedLetters[1].status, game.LetterStatus.correct);
    expect(testGame.guessedLetters[1].index, 1);

    testGame.addGuessedLetter(game.Letter('e', game.LetterStatus.correct, 2));
    expect(testGame.guessedLetters[2].letter, 'e');
    expect(testGame.guessedLetters[2].status, game.LetterStatus.correct);
    expect(testGame.guessedLetters[2].index, 2);

    testGame.addGuessedLetter(game.Letter('e', game.LetterStatus.correct, 3));
    testGame.addGuessedLetter(game.Letter('l', game.LetterStatus.correct, 4));
    expect(testGame.guessedLetters[3].letter, 'l');
    expect(testGame.guessedLetters[3].status, game.LetterStatus.correct);
    expect(testGame.guessedLetters[3].index, 4);

    expect(testGame.guessedLetters.length, 4);
  });

  test('addGuessedLetter_zzzzz_no_repeats', () {
    testGame.guessedLetters = [];
    testGame.addGuessedLetter(game.Letter('z', game.LetterStatus.absent, 0));
    testGame.addGuessedLetter(game.Letter('z', game.LetterStatus.absent, 1));
    testGame.addGuessedLetter(game.Letter('z', game.LetterStatus.absent, 2));
    testGame.addGuessedLetter(game.Letter('z', game.LetterStatus.absent, 3));
    testGame.addGuessedLetter(game.Letter('z', game.LetterStatus.absent, 4));
    expect(testGame.guessedLetters[0].letter, 'z');
    expect(testGame.guessedLetters[0].status, game.LetterStatus.absent);
    expect(testGame.guessedLetters[0].index, 0);

    expect(testGame.guessedLetters.length, 1);
  });

  test('validGuess', () {
    var valid = testGame.validGuess([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("a", game.LetterStatus.unguessed, 3),
      game.Letter("l", game.LetterStatus.unguessed, 4),
    ]);
    expect(valid, true);

    valid = testGame.validGuess([
      game.Letter("h", game.LetterStatus.unguessed, 0),
      game.Letter("e", game.LetterStatus.unguessed, 1),
      game.Letter("l", game.LetterStatus.unguessed, 2),
      game.Letter("p", game.LetterStatus.unguessed, 3),
    ]);
    expect(valid, null);

    valid = testGame.validGuess([
      game.Letter("z", game.LetterStatus.unguessed, 0),
    ]);
    expect(valid, false);

    valid = testGame.validGuess([
      game.Letter("z", game.LetterStatus.unguessed, 0),
      game.Letter("z", game.LetterStatus.unguessed, 1),
      game.Letter("z", game.LetterStatus.unguessed, 2),
      game.Letter("z", game.LetterStatus.unguessed, 3),
      game.Letter("z", game.LetterStatus.unguessed, 4),
    ]);
    expect(valid, false);
  });

  test('compareGuess', () {
    var steelLetters = [
      game.Letter('s', game.LetterStatus.correct, 0),
      game.Letter('t', game.LetterStatus.correct, 1),
      game.Letter('e', game.LetterStatus.correct, 2),
      game.Letter('e', game.LetterStatus.correct, 3),
      game.Letter('l', game.LetterStatus.correct, 4),
    ];
    var steakLetters = [
      game.Letter('s', game.LetterStatus.correct, 0),
      game.Letter('t', game.LetterStatus.correct, 1),
      game.Letter('e', game.LetterStatus.correct, 2),
      game.Letter('a', game.LetterStatus.correct, 3),
      game.Letter('k', game.LetterStatus.correct, 4),
    ];
    expect(testGame.compareGuess(steelLetters), true);
    expect(testGame.compareGuess(steakLetters), false);
  });

  //step through loops
  test('loopLogic_win', () {
    //new instance
    testWord = "steel";
    guesses = ["shore", "steak", "he;p", "help", "steel"];
    testIO = TestIO(guesses);
    testGame = game.Game(testWord, guesses.length, testIO, dictionary);
    testIO.currectGame = testGame;

    testGame.gameRunning = true;
    expect(testGame.guessCount, 0);
    expect(testGame.gameRunning, true);

    testGame.loopLogic([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("h", game.LetterStatus.unguessed, 1),
      game.Letter("o", game.LetterStatus.unguessed, 2),
      game.Letter("r", game.LetterStatus.unguessed, 3),
      game.Letter("e", game.LetterStatus.unguessed, 4),
    ]);
    expect(testGame.guessCount, 1);
    expect(testGame.gameRunning, true);

    testGame.loopLogic([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("a", game.LetterStatus.unguessed, 3),
      game.Letter("k", game.LetterStatus.unguessed, 4),
    ]);
    expect(testGame.guessCount, 2);
    expect(testGame.gameRunning, true);

    //invalid
    testGame.loopLogic([
      game.Letter("h", game.LetterStatus.unguessed, 0),
      game.Letter("e", game.LetterStatus.unguessed, 1),
      game.Letter(";", game.LetterStatus.unguessed, 2),
      game.Letter("p", game.LetterStatus.unguessed, 3),
    ]);
    expect(testGame.guessCount, 2);
    expect(testGame.gameRunning, true);

    //help
    testGame.loopLogic([
      game.Letter("h", game.LetterStatus.unguessed, 0),
      game.Letter("e", game.LetterStatus.unguessed, 1),
      game.Letter("l", game.LetterStatus.unguessed, 2),
      game.Letter("p", game.LetterStatus.unguessed, 3),
    ]);
    expect(testGame.guessCount, 2);
    expect(testGame.gameRunning, true);

    //win
    testGame.loopLogic([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("e", game.LetterStatus.unguessed, 3),
      game.Letter("l", game.LetterStatus.unguessed, 4),
    ]);
    expect(testGame.guessCount, 3);
    expect(testGame.gameRunning, false);
  });

  test('loopLogic_lose', () {
    //new instance
    testWord = "steel";
    guesses = ["shore", "steak", "stare"];
    testIO = TestIO(guesses);
    testGame = game.Game(testWord, guesses.length, testIO, dictionary);
    testIO.currectGame = testGame;

    testGame.gameRunning = true;

    testGame.loopLogic([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("h", game.LetterStatus.unguessed, 1),
      game.Letter("o", game.LetterStatus.unguessed, 2),
      game.Letter("r", game.LetterStatus.unguessed, 3),
      game.Letter("e", game.LetterStatus.unguessed, 4),
    ]);
    expect(testGame.guessCount, 1);
    expect(testGame.gameRunning, true);

    testGame.loopLogic([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("a", game.LetterStatus.unguessed, 3),
      game.Letter("k", game.LetterStatus.unguessed, 4),
    ]);
    expect(testGame.guessCount, 2);
    expect(testGame.gameRunning, true);

    //lose
    testGame.loopLogic([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("a", game.LetterStatus.unguessed, 2),
      game.Letter("r", game.LetterStatus.unguessed, 3),
      game.Letter("e", game.LetterStatus.unguessed, 4),
    ]);
    expect(testGame.guessCount, 3);
    expect(testGame.gameRunning, false);
  });

  test('submitGuess', () {
    //new instance
    testWord = "steel";
    guesses = ["shore", "steak", "stare"];
    testIO = TestIO(guesses);
    testGame = game.Game(testWord, guesses.length, testIO, dictionary);
    testIO.currectGame = testGame;

    testGame.submitGuess([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("e", game.LetterStatus.unguessed, 3),
      game.Letter("l", game.LetterStatus.unguessed, 4),
    ]);

    expect(testGame.guessCount, 0);

    testGame.gameRunning = true;

    testGame.submitGuess([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("e", game.LetterStatus.unguessed, 3),
    ]);

    expect(testGame.guessCount, 0);

    testGame.submitGuess([
      game.Letter("s", game.LetterStatus.unguessed, 0),
      game.Letter("t", game.LetterStatus.unguessed, 1),
      game.Letter("e", game.LetterStatus.unguessed, 2),
      game.Letter("e", game.LetterStatus.unguessed, 3),
      game.Letter("l", game.LetterStatus.unguessed, 4),
    ]);

    expect(testGame.guessCount, 1);
  });
}

class TestIO implements game.GameIO {
  late final game.Game currectGame;
  List<String> guesses;
  late String testInput;

  TestIO(this.guesses) {
    testInput = guesses[0];
  }

  @override
  void showGuess(List<game.Letter> letters) {}

  @override
  void showLetters() {}

  @override
  void showHelp() {}

  @override
  void promptGuess() {}

  @override
  List<game.Letter> readGuess() {
    return [];
  }

  @override
  void promptValidGuess() {}

  @override
  void promptCorrect() {}

  @override
  void promptGameOver() {}

  @override
  void promptIncorrect() {}
}
