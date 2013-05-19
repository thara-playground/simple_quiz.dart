import 'dart:html';
import 'dart:async';

import "package:simple_quiz/simple_quiz.dart";

Stream<MouseEvent> delegateOnClick(String selector) =>
    document.onClick.where(
        (e) => e.target.matches(selector));

void main() {
  
  List<Quiz> quizzes = [
    new Quiz(question("choose B.")
              ..correctAnswer = "B"
              ..incorrectAnswers = ["A", "C", "D"]),
    new Quiz(question("choose C.")
        ..correctAnswer = "C"
        ..incorrectAnswers = ["A", "B", "D"])
  ];
  
  var quizPresenter = new WebQuizPresenter();
  
  quizPresenter.showTitle(quizzes);
  
  var quizMaster = new QuizMaster(quizzes, quizPresenter);
  
  var stream = delegateOnClick("input[name='selected_answer']")
                .transform(new SelectedAnswerTransformer());
  
  quizMaster.beginQuiz(stream.listen(null));
}

class SelectedAnswerTransformer extends StreamEventTransformer<MouseEvent, String> {
  
  void handleData(MouseEvent event, EventSink<String> sink) {
    sink.add((event.target as InputElement).value);
  }
}

class WebQuizPresenter implements QuizPresenter {
  
  final Element feedback = query("#quiz_feedback");
  final Element sentence = query("#quiz_sentence");
  
  final Element choices = query("#quiz_choices");
  
  void showTitle(List<Quiz> quizzes) {
    feedback.text = "Answer ${quizzes.length} quizzes.";
  }
  
  void showPrepareAnswer() {
    // NOP
  }
  
  void showQuiz(QuizEntry quizEntry) {
    sentence.text = "Quiz ${quizEntry.quizNo} : ${quizEntry.quiz.sentence}";
    
    choices.children.clear();
    
    quizEntry.choices.forEach((choiceNo, answer) {

      var button = new RadioButtonInputElement();
      button
        ..name = "selected_answer"
        ..value = "$choiceNo";
      
      var li = new LIElement();
      li.children.add(button);
      li.onClick.listen((e) {
        button.click();
      });
      
      var label = new Element.html("<label>$choiceNo : ${answer.content}</label>");
      li.children.add(label);
      
      choices.children.add(li);
    });
  }
  
  void showResults(List<QuizEntry> entries) {
    
    sentence.remove();
    choices.remove();
    
    feedback.text = "Well done!";
    
    var resultFutures = entries.map((e) => e.quiz.select(e.seletedAnswer));
    Future.wait(resultFutures).then((List<bool> results) {
      var correctCount = results.where((b) => b).length;
      var msg = new Element.html("<p>Your result :  ${correctCount}/${results.length}</p>");
      feedback.append(msg);
    });
  }
}