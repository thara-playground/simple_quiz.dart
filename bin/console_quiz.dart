
import "dart:io";
import "dart:math";
import "dart:async";

import '../lib/simple_quiz.dart';

void main() {
  
  List<Quiz> quizzes = [
    new Quiz(question("choose B.")
              ..correctAnswer = "B"
              ..incorrectAnswers = ["A", "C", "D"]),
    new Quiz(question("choose C.")
        ..correctAnswer = "C"
        ..incorrectAnswers = ["A", "B", "D"])
  ];
  
  print("Answer ${quizzes.length} quizzes.");
 
  var quizMaster = new QuizMaster(quizzes, new ConsoleQuizPresenter());
  
  var cmdLine = stdin
                  .transform(new StringDecoder())
                  .transform(new LineTransformer());
  var userInteraction = cmdLine.listen(null);
  
  quizMaster.prepareAnswerBy(userInteraction);
  
  quizMaster.beginQuiz();
}

class ConsoleQuizPresenter extends QuizPresenter {
  
  void showQuiz(QuizEntry quizEntry) {
    stdout.writeln("=================================");
    stdout.writeln("Quiz ${quizEntry.quizNo}: ${quizEntry.quiz.sentence}");
    
    quizEntry.choices.forEach((choiceNo, answer) {
      stdout.writeln("$choiceNo:${answer.content}");
    });
  }
  
  void showPrepareAnswer() {
    stdout.write("Input your answer :");
  }
  
  void showInputError(String input) {
    stdout.write("REJECTED YOUR INPUT : ");
    stdout.writeln("Input a number of the correct answer from choices.");
  }
  
  void showResults(List<QuizEntry> entries) {
    stdout.writeln("=================================");
    stdout.writeln("     Well done!                  ");
    stdout.writeln("=================================");
    
    var resultFutures = entries.map((e) => e.quiz.select(e.seletedAnswer));
    Future.wait(resultFutures).then((List<bool> results) {
      var correctCount = results.where((b) => b).length;
      stdout.writeln("Your result :  ${correctCount}/${results.length}");
    });
  }
}