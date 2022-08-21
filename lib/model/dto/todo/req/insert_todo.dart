// 데이터를 서버로 보낼 때,
// 생성자 만들기


// 서버로 보내기
import 'dart:convert';

class InsertTodo{
  final String content;

  InsertTodo({String content = ''})
  :this.content = content;

  Map<String, dynamic> toJsonMap() => {
    "content" : content
  };

  String toRowJson() => jsonEncode(toJsonMap());
}