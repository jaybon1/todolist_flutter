import 'dart:math';
import 'package:get/get_connect.dart';
import 'package:todolist/model/dto/common/res_dto.dart';
import 'package:todolist/model/dto/todo/req/insert_todo.dart';
import 'package:todolist/model/dto/todo/req/update_todo.dart';
import 'package:todolist/model/dto/todo/res/todo.dart';
import 'package:todolist/utils/constants.dart';
import 'package:todolist/utils/utils.dart';

class TodoRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = "${Constants.baseUrl}/todo";

    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'token ${Random().nextInt(100)}';
      return request;
    });
  }

  // 할일 등록
  Future<ResDto<Todo?>> insertTodo(InsertTodo insertTodo) async {
    Response response = await post("/", insertTodo.toMap());

    handleData(data) {
      return Todo.fromMap(data);
    }

    return Utils.handleResDto(response, handleData: handleData);

  }

  // 할일 수정
  Future<ResDto<Todo?>> updateTodo(int idx, UpdateTodo updateTodo) async {
    final Map<String, String> query = {"idx": idx.toString()};

    Response response = await put("/", updateTodo.toMap(), query: query);

    handleData(data) {
      return Todo.fromMap(data);
    }

    return Utils.handleResDto(response, handleData: handleData);

  }

  // 할일삭제
  Future<ResDto<dynamic>> deleteTodo(int idx) async {
    Response response = await delete('/$idx');

    return Utils.handleResDto(response);

  }

  // 할일 리스트
  Future<ResDto<List<Todo>?>> getList() async {

    // 통신
    Response response = await get("/");

    // 데이터 가공 메서드 선언
    handleData(data) {
      return (data as List).map((e) => Todo.fromMap(e)).toList();
    }

    // 데이터 가공
    return Utils.handleResDto(response, handleData: handleData);

  }
}


