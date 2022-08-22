import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:todolist/model/dto/common/response_dto.dart';
import 'package:todolist/model/dto/todo/req/insert_todo.dart';
import 'package:todolist/model/dto/todo/req/update_todo.dart';
import 'package:todolist/model/dto/todo/res/todo.dart';
import 'package:todolist/model/repository/todo_repository.dart';
import 'package:todolist/utils/utils.dart';

class TodoViewmodel extends GetxController {
  static TodoViewmodel get to => Get.find();
  final TextEditingController textEditingController = TextEditingController();
  var logger = Logger();

  final TodoRepository todoRepository = Get.put(TodoRepository());

  // 할일리스트
  final RxList<Todo> _todoList = <Todo>[].obs;

  // 할일완료
  final RxList<Todo> _doneList = <Todo>[].obs;

  @override
  void onInit() {
    _getList(); // 할일리스트 초기화
    super.onInit();
  }

  // 할일 가져오기
  Future<void> _getList() async {
    Response response = await todoRepository.getList();
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse =
          jsonDecode(response.bodyString!);
      final responseDto = ResponseDto<List<Todo>>(
        code: decodedResponse["code"],
        message: decodedResponse["message"],
        data: (decodedResponse["data"] as List)
            .map((e) => Todo.fromJsonMap(e))
            .toList(),
      );

      _todoList.value =
          responseDto.data!.where((element) => element.doneYn == "N").toList();
      _doneList.value =
          responseDto.data!.where((element) => element.doneYn == "Y").toList();
    } else {
      Utils.errorHandle(response);
    }
  }

  // 할일등록
  Future<void> create() async {
    final InsertTodo insertTodo =
        InsertTodo(content: textEditingController.text);
    // 통신
    Response response = await todoRepository.insertTodo(insertTodo);
    if (response.statusCode == 200) {
      _getList();
    } else {
      Utils.errorHandle(response);
    }
    textEditingController.text = '';
  }

  // 할일완료
  void done(Todo todo) async {
    final UpdateTodo updateTodo =
        UpdateTodo(doneYn: todo.doneYn == "Y" ? "N" : "Y");
    // 통신
    Response response = await todoRepository.updateTodo(todo.idx, updateTodo);
    if (response.statusCode == 200) {
      _getList();
    } else {
      Utils.errorHandle(response);
    }
  }

  // 할일삭제
  void delete(int idx) async {
    Response response = await todoRepository.deleteTodo(idx);
    if (response.statusCode == 200) {
      _getList();
    } else {
      Utils.errorHandle(response);
    }
  }

  // List get checkedList => _checkedList;
  List<Todo> get todoList => _todoList.value;

  List<Todo> get doneList => _doneList.value;
}
