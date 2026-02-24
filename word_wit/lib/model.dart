class Game {
  String secretWord;
  List<String> dictionary;
  int guessCount = 0;
  int maxGuesses;
  GameIO gameIO;
  bool gameRunning = false;
  final String keys = "qwertyuiopasdfghjkl\n\u{232B}zxcvbnm\u{21B5}";
  List<Letter> guessedLetters = [];
  List<Letter> keyboardLetters = [];
  List<List<Letter>> playerGuesses = [[]];

  Game(this.secretWord, this.maxGuesses, this.gameIO, this.dictionary);

  void populateKeyboard() {
    for (var i = 0; i < keys.length; i++) {
      Letter newLetter = Letter(keys[i], LetterStatus.contained, 0);
      keyboardLetters.add(newLetter);
    }
  }

  void startGame() {
    gameRunning = true;
  }

  // void gameLoop() {
  //   while (gameRunning) {
  //     loopLogic();
  //   }
  // }

  void submitGuess(List<Letter> entry) {
    if (entry.length == 5 && gameRunning) loopLogic(entry);
  }

  void loopLogic(List<Letter> entry) {
    gameIO.promptGuess();
    List<Letter> guess = entry;
    //is guesss valid?
    var valid = validGuess(guess);
    if (valid == null) {
      gameIO.showHelp();
      //return to guess again
      return;
    } else if (valid == false) {
      gameIO.promptValidGuess();
      return;
    }
    guessCount++;
    var guessLetters = checkWord(guess);
    playerGuesses.add(guessLetters);
    gameIO.showGuess(guessLetters);
    if (compareGuess(guessLetters)) {
      gameIO.promptCorrect();
      //gameIO.showGuess(guessLetters);
      gameRunning = false;
    } else {
      //gameIO.showGuess(guessLetters);
      gameIO.promptIncorrect();
    }
    if (guessCount == maxGuesses) {
      gameIO.promptGameOver();
      gameRunning = false;
    }
  }

  bool compareGuess(List<Letter> guessletters) {
    for (var i = 0; i < secretWord.length; i++) {
      if (guessletters[i].letter != secretWord[i]) {
        return false;
      }
    }
    return true;
  }

  List<Letter> checkWord(List<Letter> guessStr) {
    List<Letter> guessLetters = [];
    for (var i = 0; i < guessStr.length; i++) {
      var letter = checkLetter(guessStr[i].letter, i);
      //check for duplicates
      guessLetters.add(letter);
      addGuessedLetter(letter);
    }
    //remove duplicates
    guessLetters = checkDuplicate(guessLetters);
    return guessLetters;
  }

  void addGuessedLetter(Letter letter) {
    bool alreadyGuessed = false;
    Letter? letterToReplace;
    for (var ltr in guessedLetters) {
      if (ltr.letter == letter.letter) {
        alreadyGuessed = true;
        //check status, update if higher priority
        if (ltr.status.index < letter.status.index) {
          letterToReplace = ltr;
        }
        //exit loop if found
        break;
      }
    }
    //was it found?
    if (!alreadyGuessed) {
      guessedLetters.add(letter);
    }
    //letter to replace?
    if (letterToReplace != null) {
      guessedLetters.remove(letterToReplace);
      guessedLetters.add(letter);
    }
  }

  Letter checkLetter(String ch, int index) {
    //default status is absent
    var letter = Letter(ch, LetterStatus.absent, index);
    for (var i = 0; i < secretWord.length; i++) {
      //does letter match?
      if (secretWord[i] == ch) {
        //is it in the same spot? if yes, correct; if on, contained.
        if (i == index) {
          letter.status = LetterStatus.correct;
          //break on correct letter in guess
          break;
        } else {
          letter.status = LetterStatus.contained;
        }
      }
    }
    return letter;
  }

  List<Letter> checkDuplicate(List<Letter> guessLetters) {
    var charCounterSecret = <String, int>{};
    for (var i = 0; i < secretWord.length; i++) {
      var ch = secretWord[i];
      charCounterSecret[ch] = (charCounterSecret[ch] ?? 0) + 1;
    }
    var charCounterGuess = <String, int>{};
    for (var ltr in guessLetters) {
      var ch = ltr.letter;
      charCounterGuess[ch] = (charCounterGuess[ch] ?? 0) + 1;
    }
    //check for exceeding letters
    for (var key in charCounterGuess.keys) {
      //does letter occur more times than in secret?
      var guessCharCount = charCounterGuess[key];
      var secretCharCount = charCounterSecret[key];
      //is it in secret?
      if (secretCharCount == null) {
        // go to next letter
        continue;
      }
      //does it occur more than secret?
      if ((guessCharCount ?? 0) > secretCharCount) {
        //correct letters
        for (var i = 0; i < (guessCharCount ?? 0) - secretCharCount; i++) {
          for (var j = 0; j < guessLetters.length; j++) {
            //start from end
            //if letter matches
            var ltr = guessLetters[guessLetters.length - 1 - j];
            if (ltr.letter == key) {
              //if letter is marked contained
              if (ltr.status == LetterStatus.contained) {
                //mark absent
                ltr.status = LetterStatus.absent;
                break;
              }
            }
          }
        }
      }
    }

    return guessLetters;
  }

  bool? validGuess(List<Letter> guess) {
    if (guess.length == 5) {
      //check dictionary
      return dictionary.contains(letterListToString(guess));
    } else if (letterListToString(guess) == "help") {
      return null;
    } else {
      return false;
    }
  }

  String letterListToString(List<Letter> letters) {
    String result = "";
    for (var ltr in letters) {
      result += ltr.letter;
    }
    return result;
  }
}

abstract interface class GameIO {
  void showGuess(List<Letter> letters);
  void showLetters();
  void showHelp();
  void promptGuess();
  List<Letter> readGuess();
  void promptValidGuess();
  void promptCorrect();
  void promptGameOver();
  void promptIncorrect();
}

enum LetterStatus { unguessed, absent, contained, correct }

class Letter {
  String letter;
  LetterStatus status;
  int index;
  Letter(this.letter, this.status, this.index);

  @override
  String toString() {
    return "$letter at $index is $status";
  }
}
