// 데이터를 서버로 보낼 때,
// 생성자 만들기

import 'dart:convert';

class UpdateTodo{
  final String doneYn;

  UpdateTodo({String doneYn = ''})
  :this.doneYn = doneYn;

  Map<String, dynamic> toMap() => {
    "doneYn": doneYn
  };

  String toJson() => jsonEncode(toMap());
}