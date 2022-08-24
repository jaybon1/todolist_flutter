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


  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
    idx: map["idx"],
    content: map["content"],
    doneYn: map["doneYn"],
  );
  
  // json은 원래 String, 
  factory Todo.fromJson(String json) => Todo.fromMap(jsonDecode(json));

}