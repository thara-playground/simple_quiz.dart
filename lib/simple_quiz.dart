library simple_quiz;

import "dart:async";
import 'dart:math';

part "src/simple_quiz/quiz.dart";
part "src/simple_quiz/answer.dart";
part "src/simple_quiz/quiz_master.dart";
part "src/simple_quiz/presenter.dart";
part "src/simple_quiz/quiz_entry.dart";

Question question(String sentence) => new Question()..sentence = sentence;

class IllegalInputException implements Exception {}