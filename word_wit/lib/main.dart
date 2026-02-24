import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:word_wit/model.dart' as model;
import 'package:word_wit/read_words.dart' as infile;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Word Wit'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _maxGuesses = 6;
  final int _wordLength = 5;
  late int _guessIndex;
  late _Gameplay _currentGame;
  late model.Game _currentModel;
  String _promptMessage = initialPromptString;
  late final List<String> dictionary;
  final focus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focus.requestFocus();
  }

  _MyHomePageState() {
    infile.collectWords().then((value) {
      var random = Random();
      var index = random.nextInt(value.length);
      _currentModel.secretWord = value[index];
      _currentModel.dictionary = value;
      dictionary = value;
      _currentModel.startGame();
    });
    _currentGame = _Gameplay(this);
    _currentModel = model.Game("", _maxGuesses, _currentGame, []);
    _currentGame.currentGame = _currentModel;
    _guessIndex = 0;
  }

  //Colors
  static const lightGreyColor = Color.fromARGB(255, 240, 235, 240);
  static const darkGreyColor = Colors.grey;
  static const yellowColor = Colors.yellow;
  static const greenColor = Colors.green;

  static const correctString = "Correct!";
  static const initialPromptString = "Guess a 5-letter word.";
  static const invalidString = "Not in word list.";
  static const answerString = "The word is ";
  static const incorrectString = "Wrong, try again.";
  static const answerStringEnd = ".";

  final _statusColors = {
    model.LetterStatus.unguessed: lightGreyColor,
    model.LetterStatus.absent: darkGreyColor,
    model.LetterStatus.contained: yellowColor,
    model.LetterStatus.correct: greenColor,
  };

  void _addLetterToGuess(model.Letter letter) {
    if (!_currentModel.gameRunning) return;
    setState(() {
      if (_currentGame.playerGuesses[_guessIndex].length < 5) {
        _currentGame.playerGuesses[_guessIndex].add(letter);
      }
    });
  }

  void _deleteLetterFromGuess() {
    if (!_currentModel.gameRunning) return;
    setState(() {
      if (_currentGame.playerGuesses[_guessIndex].isNotEmpty) {
        _currentGame.playerGuesses[_guessIndex].removeLast();
      }
    });
  }

  void _enterGuess() {
    if (!_currentModel.gameRunning) return;
    setState(() {
      //submit guess to check
      //write a function in model that submits guess and calls game loop once
      //call other functions from observer to enact results.
      _currentModel.submitGuess(_currentGame.playerGuesses[_guessIndex]);
    });
  }

  void _showGuessResults() {
    setState(() {
      _guessIndex = _currentModel.guessCount;
    });
  }

  void _showCorrect() {
    setState(() {
      _promptMessage = correctString;
    });
  }

  void _showInvalidGuess() {
    setState(() {
      _promptMessage = invalidString;
    });
  }

  void _showAnswer() {
    setState(() {
      _promptMessage =
          answerString + _currentModel.secretWord + answerStringEnd;
    });
  }

  void _showIncorrect() {
    setState(() {
      _promptMessage = incorrectString;
    });
  }

  void _restart() {
    setState(() {
      _currentGame = _Gameplay(this);
      var random = Random();
      var index = random.nextInt(dictionary.length);
      _currentModel = model.Game(
        dictionary[index],
        _maxGuesses,
        _currentGame,
        dictionary,
      );
      _currentGame.currentGame = _currentModel;
      _currentModel.startGame();
      _promptMessage = initialPromptString;
      _guessIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: KeyboardListener(
        autofocus: true,
        focusNode: focus,
        onKeyEvent: (value) {
          if (value is KeyDownEvent) {
            var letterKeys = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            if (letterKeys.contains(value.logicalKey.keyLabel)) {
              _addLetterToGuess(
                model.Letter(
                  value.logicalKey.keyLabel.toLowerCase(),
                  model.LetterStatus.unguessed,
                  0,
                ),
              );
            } else if (value.logicalKey.keyLabel == "Backspace") {
              _deleteLetterFromGuess();
            } else if (value.logicalKey.keyLabel == "Enter") {
              _enterGuess();
            }
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                //Header
                Text(
                  _promptMessage,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                //Guesses
                SizedBox(
                  width: 320.0,
                  height: 400.0,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: GridView.count(
                        crossAxisCount: _wordLength,
                        children: List.generate(
                          _wordLength * _maxGuesses,
                          (index) => Center(
                            child: SizedBox(
                              width: 75,
                              height: 75,
                              child: Card(
                                color:
                                    _statusColors[(_currentGame
                                            .attemptPlayerGuessesAccess(
                                              index ~/ 5,
                                              index % 5,
                                            )
                                            ?.status ??
                                        model.LetterStatus.unguessed)],
                                child: Center(
                                  child: Text(
                                    _currentGame
                                            .attemptPlayerGuessesAccess(
                                              index ~/ 5,
                                              index % 5,
                                            )
                                            ?.letter ??
                                        "",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displaySmall,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //keyboard
                SizedBox(
                  width: 320,
                  height: 160,
                  child: GridView.count(
                    crossAxisCount: 10,
                    childAspectRatio: 0.618,
                    children: List.generate(_currentGame.keys.length, (index) {
                      var key = _currentGame.keys[index];
                      var color =
                          _statusColors[_currentGame
                              .keyboardLetters[index]
                              .status];
                      var onPressed = () {
                        _addLetterToGuess(
                          model.Letter(key, model.LetterStatus.unguessed, 0),
                        );
                      };
                      if (key == "\n") {
                        return Container();
                      }
                      if (key == "\u{232B}") {
                        onPressed = () {
                          _deleteLetterFromGuess();
                        };
                        color = lightGreyColor;
                      } else if (key == "\u{21B5}") {
                        onPressed = () {
                          _enterGuess();
                        };
                        color = lightGreyColor;
                      }
                      return Container(
                        margin: EdgeInsets.all(1.0),
                        child: TextButton(
                          onPressed: onPressed,
                          style: TextButton.styleFrom(
                            alignment: AlignmentGeometry.center,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(2.0),
                            ),
                            backgroundColor: color,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            _currentGame.keys[index],
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        tooltip: 'New Game',
        child: const Icon(Icons.redo),
      ),
    );
  }
}

//gameplay
class _Gameplay with ChangeNotifier implements model.GameIO {
  final String keys = "qwertyuiopasdfghjkl\n\u{232B}zxcvbnm\u{21B5}";
  List<model.Letter> keyboardLetters = [];
  List<List<model.Letter>> playerGuesses = [[]];
  late final model.Game currentGame;
  final _MyHomePageState gui;

  _Gameplay(this.gui) {
    populateKeyboard();
  }

  void populateKeyboard() {
    for (var i = 0; i < keys.length; i++) {
      model.Letter newLetter = model.Letter(
        keys[i],
        model.LetterStatus.unguessed,
        0,
      );
      keyboardLetters.add(newLetter);
    }
  }

  model.Letter? attemptPlayerGuessesAccess(int guess, int index) {
    try {
      return playerGuesses[guess][index];
    } on RangeError {
      return null;
    }
  }

  void syncKeyboard() {
    for (var i = 0; i < currentGame.guessedLetters.length; i++) {
      for (var j = 0; j < keyboardLetters.length; j++) {
        if (currentGame.guessedLetters[i].letter == keyboardLetters[j].letter) {
          keyboardLetters[j].status = currentGame.guessedLetters[i].status;
        }
      }
    }
  }

  @override
  void promptCorrect() {
    gui._showCorrect();
  }

  @override
  void promptGameOver() {
    gui._showAnswer();
  }

  @override
  void promptGuess() {
    //gui._showInitialPrompt();
  }

  @override
  void promptValidGuess() {
    gui._showInvalidGuess();
  }

  @override
  List<model.Letter> readGuess() {
    throw UnimplementedError();
  }

  @override
  void showGuess(List<model.Letter> letters) {
    playerGuesses.add([]);
    playerGuesses[currentGame.guessCount - 1] = letters;
    syncKeyboard();
    gui._showGuessResults();
  }

  @override
  void showHelp() {
    gui._showAnswer();
  }

  @override
  void showLetters() {
    // TODO: implement showLetters
  }

  @override
  void promptIncorrect() {
    gui._showIncorrect();
  }
}
