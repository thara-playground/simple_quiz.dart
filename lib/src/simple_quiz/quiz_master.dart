part of simple_quiz;

class QuizMaster {
  
  final List<Quiz> _quizzes;
  
  QuizPresenter _quizPresenter;
  
  Iterator<QuizEntry> _quizIter;
  
  StreamController<QuizEntry> _quizStreamController;
  StreamSubscription<QuizEntry> _quizSubscription;
  
  List<QuizEntry> _answeredQuiz = [];
  
  QuizMaster(List<Quiz> quizzes, this._quizPresenter) : this._quizzes = quizzes {
    
    var quizEntries = <QuizEntry>[];
    quizzes.asMap().forEach((quizNo, quiz) {
      quizEntries.add(new QuizEntry(quizNo, quiz));
    });
    
    this._quizIter = quizEntries.iterator;
    
    this._quizStreamController = new StreamController<QuizEntry>();
    this._quizSubscription = _quizStreamController.stream.listen(null);
  }
  
  void beginQuiz() {
    _proposeNextQuiz();
  }
  
  void prepareAnswerBy(StreamSubscription<String> answerAction) {
    
    _quizSubscription.onData((QuizEntry quizEntry) {
      _quizPresenter.showQuiz(quizEntry);
      _quizPresenter.showPrepareAnswer();
      
      answerAction.onData((input) {
        
        try {
          quizEntry.choice(input);
        } on IllegalInputException {
          _quizPresenter.showInputError(input);
        }
        
        if (quizEntry.isAnswered()) {
          
          _answeredQuiz.add(quizEntry);
          
          _proposeNextQuiz(handleNoLeftQuiz : () {
            answerAction.cancel();
            _quizStreamController.close();
          });
          
        } else {
          // retry answer
          _quizPresenter.showPrepareAnswer();
        }
      });
    });
    
    _quizSubscription.onDone(() {
      
      _quizPresenter.showResults(this._answeredQuiz);
    });
  }
  
  void _proposeNextQuiz({void handleNoLeftQuiz()}) {
    if (_quizIter.moveNext()) {
      _quizStreamController.add(_quizIter.current);
    } else if (?handleNoLeftQuiz) {
      handleNoLeftQuiz();
    }
  }
}