import "package:simple_quiz/simple_quiz.dart";

import "package:unittest/unittest.dart";

main () {
  
  test("Question setup error", () {
    expect(() => new Quiz(
                  question("choose B.")
                    ..correctAnswer = "B"
                    ..incorrectAnswers = ["A", "B", "C"]),
        throwsA(new isInstanceOf<ArgumentError>()));
  });
  
  test("chooseAnswer", () {
    
    var quiz = new Quiz(question("choose A.")
        ..correctAnswer = "A"
        ..incorrectAnswers = ["B", "C"]);
    
    var choices = quiz.getChoices();
    
    quiz.select(new Answer("A")).then((actual) => expect(actual, isTrue));
    quiz.select(new Answer("B")).then((actual) => expect(actual, isFalse));
    quiz.select(new Answer("C")).then((actual) => expect(actual, isFalse));
  });
}

