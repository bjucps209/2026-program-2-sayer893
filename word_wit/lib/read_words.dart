import 'package:flutter/services.dart';

Future<List<String>> getLines() async {
  var data = await rootBundle.loadString("assets/wordlist.txt");
  var words = data.split('\n');
  for (var i = 0; i < words.length; i++) {
    words[i] = words[i].trim();
  }
  return words;
}

Future<List<String>> collectWords() async {
  var words = await getLines();
  for (var i = 0; i < words.length; i++) {
    if (words[i].length != 5) {
      words.removeAt(i);
      i--;
    }
  }
  return words;
}
