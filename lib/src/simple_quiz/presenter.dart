part of simple_quiz;

abstract class QuizPresenter {
  
  void showQuiz(QuizEntry quizEntry);
  
  void showPrepareAnswer();
  
  void showInputError(String input);
  
  void showResults(List<QuizEntry> entries);
}
