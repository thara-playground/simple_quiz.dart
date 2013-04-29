part of simple_quiz;

class Answer {
  
  final String content;
  
  const Answer(this.content);
  
  int get hashCode => content.hashCode;
  
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is Answer == false) return false;
    return this.content == (other as Answer).content;    
  }
}