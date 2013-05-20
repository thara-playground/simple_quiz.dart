part of simple_quiz;

class Quiz {

  final String sentence;
  final Answer correctAnswer;
  final List<Answer> incorrectAnswers;
  
  Quiz._(this.sentence, this.correctAnswer, this.incorrectAnswers);
  
  factory Quiz(Question q) {
    var sentence = q.sentence;
    var correctAnswer = new Answer(q.correctAnswer);
    var incorrectAnswers = q.incorrectAnswers.map((s) => new Answer(s)).toList();
    
    if (incorrectAnswers.contains(correctAnswer)) throw new ArgumentError();
    
    return new Quiz._(sentence, correctAnswer, incorrectAnswers);
  }
  
  List<Answer> getChoices() {
    var choices = [correctAnswer]..addAll(incorrectAnswers);
    
    // shuffle choices.
    void swap(int from, int to) {
      var temp = choices[from];
      choices[from] = choices[to];
      choices[to] = temp;
    }
    
    var random = new Random();
    for (var n = choices.length - 1; n > 0; n--) {
      var k = random.nextInt(choices.length);
      swap(n - 1, k);
    }
    
    return choices;
  }
  
  Future<bool> select(Answer answer) => 
      new Future<bool>.sync(() => this.correctAnswer == answer);
}

class Question {
  String sentence;
  String correctAnswer;
  List<String> incorrectAnswers;
}