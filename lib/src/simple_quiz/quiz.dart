part of simple_quiz;

class Quiz {

  final String sentence;
  final Answer correctAnswer;
  final List<Answer> incorrectAnswers;
  
  Quiz(Question q)
    : this.sentence = q.sentence,
      this.correctAnswer = new Answer(q.correctAnswer),
      this.incorrectAnswers = q.incorrectAnswers.map((s) => new Answer(s)).toList() {
      
      if (this.incorrectAnswers.contains(this.correctAnswer)) throw new ArgumentError();      
    }
  
  List<Answer> getChoices() {
    var choices = [correctAnswer]..addAll(incorrectAnswers);
    
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