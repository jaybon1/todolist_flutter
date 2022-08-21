import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:logger/logger.dart';
import 'package:todolist/model/dto/common/response_dto.dart';
import 'package:todolist/model/dto/todo/req/insert_todo.dart';
import 'package:todolist/model/dto/todo/req/update_todo.dart';
import 'package:todolist/model/dto/todo/res/todo.dart';

class TodoRepository extends GetConnect {
  var logger = Logger();
  static TodoRepository? _instance; // _ : private / static으로 처음에 뜨고, 다른곳에서는 접근 못함, 처음에는 Null이기 때문에 ?를 넣어줌

  static const TODO_URL = "http://172.30.1.68:8091/todo"; // 상수는 모든 글자를 대문자, 띄어쓰기를 언더바로 구분

  TodoRepository._(); // ._() : 생성자, 바깥에서 생성자 접근 못함

  static TodoRepository get getInstance => // 처음에 값이 없으면 TodoRepository._()를 호출
      _instance ??= TodoRepository._(); //  ??= : _instance가 없으면 TodoConnect._()실행

  // controller에서는 async, await를 쓰기 때문에 굳이 Future를 쓸 필요가 없다. void로 사용 가능

  // 할일등록
  Future<ResponseDto<Todo?>> insertTodo(InsertTodo insertTodo) async {
    Response response = await post(TODO_URL, insertTodo.toJsonMap());
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.bodyString!); // json -> dart의 객체로 만들어줌
      final responseDto = ResponseDto<Todo>(
          code: decodedResponse["code"],
          message: decodedResponse["message"],
          data: Todo.fromJsonMap(decodedResponse["data"]) // 객체로 만들어야하니까
          );
      return responseDto;
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.bodyString!);
      final responseDto = ResponseDto<Todo>(
        code: decodedResponse["code"],
        message: decodedResponse["message"],
      );
      return responseDto;
    } else {
      return ResponseDto();
    }
  }

  // 할일수정
  Future<ResponseDto<Todo?>> updateTodo(int idx, UpdateTodo updateTodo) async {
    final Map<String, String> query = {"idx": idx.toString()};
    Response response = await put(TODO_URL, updateTodo.toJsonMap(), query: query);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.bodyString!); // json -> dart의 객체로 만들어줌
      final responseDto = ResponseDto<Todo>(
          code: decodedResponse["code"],
          message: decodedResponse["message"],
          data: Todo.fromJsonMap(decodedResponse["data"]) // 객체로 만들어야하니까
          );
      return responseDto;
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.bodyString!);
      final responseDto = ResponseDto<Todo>(
        code: decodedResponse["code"],
        message: decodedResponse["message"],
      );
      return responseDto;
    } else {
      return ResponseDto();
    }
  }

  // 할일삭제
  Future<ResponseDto<dynamic>> deleteTodo(int idx) async {
    Response response = await delete('$TODO_URL/$idx');
    if (response.statusCode == 200 || response.statusCode == 400) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.bodyString!); // json -> dart의 객체로 만들어줌
      final responseDto = ResponseDto<Todo>(
        code: decodedResponse["code"],
        message: decodedResponse["message"],
      );
      return responseDto;
    } else {
      return ResponseDto();
    }
  }

  // 통신 -> statusCode확인 -> 200일 경우 data가 안에 있기 때문에, code, message, data를 모두 넣어줄 수 있다.
  Future<ResponseDto<List<Todo>?>> getList() async {
    // data 값이 없을 수 있기 때문에 ? 를 붙여줌
    Response response = await get(TODO_URL); // getConnect의 Response

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.bodyString!);
      final responseDto = ResponseDto<List<Todo>>(
          code: decodedResponse["code"],
          message: decodedResponse["message"],
          data: (decodedResponse["data"] as List).map((e) => Todo.fromJsonMap(e)).toList());
      return responseDto;
    } else {
      // 200이외의 코드일 경우를 대비해서 기본값 세팅 필요, 기본값이 없으면 에러남
      return ResponseDto();
    }
  }
}
