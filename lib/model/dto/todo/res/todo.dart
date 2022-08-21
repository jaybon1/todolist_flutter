import 'dart:convert';

// 서버로 받기
class Todo{
  int idx;
  String content;
  String doneYn;

  Todo({
    required this.idx,
    required this.content,
    required this.doneYn
  });
  
  // json은 원래 String, 
  factory Todo.fromRawJson(String str) => Todo.fromJsonMap(jsonDecode(str));

  // factory는 싱글톤 패턴을 쓸때 사용  
  factory Todo.fromJsonMap(Map<String, dynamic> json) => Todo(
    idx: json["idx"],
    content: json["content"],
    doneYn: json["doneYn"],
  );
  
}