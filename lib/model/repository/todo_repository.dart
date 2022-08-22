import 'package:get/get_connect.dart';
import 'package:todolist/model/dto/todo/req/insert_todo.dart';
import 'package:todolist/model/dto/todo/req/update_todo.dart';

class TodoRepository extends GetConnect {

  @override
  void onInit() {
    httpClient.baseUrl = "http://172.30.1.28:8091/todo";

    print('${httpClient.baseUrl}');
    super.onInit();
  }

  // 할일 등록
  Future<Response> insertTodo(InsertTodo insertTodo) {
    return post("/", insertTodo.toJsonMap());
  }

  // 할일 수정
  Future<Response> updateTodo(int idx, UpdateTodo updateTodo) async {
    final Map<String, String> query = {"idx": idx.toString()};
    return put("/", updateTodo.toJsonMap(), query: query);
  }

  // 할일삭제
  Future<Response> deleteTodo(int idx) async {
    return delete('/$idx');
  }

  // 할일 리스트
  Future<Response> getList() {
    return get("");
  }
  
}
