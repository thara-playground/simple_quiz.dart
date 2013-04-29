part of simple_quiz;

class QuizEntry {
  
  final int quizNo;
  final Quiz quiz;
  
  final Map<int, Answer> choices;
  
  Answer _selectedAnswer;

  QuizEntry(this.quizNo, Quiz quiz)
    : this.quiz = quiz,
      choices = quiz.getChoices().asMap();
  
  void choice(String inputStr) {
    
    int input;
    try {
      input = int.parse(inputStr);
    } on FormatException {
      throw new IllegalInputException();
    }
    
    if (choices.containsKey(input)) {
      _selectedAnswer = choices[input];
    } else {
      throw new IllegalInputException();
    }
  }
  
  bool isAnswered() => this._selectedAnswer != null;
  
  Answer get seletedAnswer => this._selectedAnswer;
}