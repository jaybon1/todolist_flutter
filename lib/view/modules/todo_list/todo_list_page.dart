import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:todolist/model/repository/todo_repository.dart';
import 'package:todolist/viewmodel/todo_viewmodel.dart';

class TodoListPage extends GetView<TodoViewmodel> {
  TodoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewmodel = Get.put(TodoViewmodel());

    var logger = Logger();
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white70,
        title: const Text(
          'TODOLIST',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 250,
                        child: TextField(
                          controller: viewmodel.textEditingController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 15),
                              border: OutlineInputBorder(),
                              labelText: '할일을 입력해주세요'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => viewmodel.create(),
                        child: Container(
                          alignment: Alignment.center,
                          width: 70,
                          height: 50,
                          color: Colors.amber,
                          child: Text(
                            '등록',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 할일리스트
                  Obx(() => Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewmodel.todoList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(children: [
                              Checkbox(
                                value: viewmodel.todoList[index].doneYn == "Y", // Y로 나와야 할일완료로 넘어감
                                onChanged: (val) {
                                  // 안쓰는 val
                                  viewmodel.done(viewmodel.todoList[index]);
                                },
                              ),
                              Text(viewmodel.todoList[index].content)
                            ]);
                          },
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 500,
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Already DONE',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Obx(() => Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewmodel.doneList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: viewmodel.doneList[index].doneYn == "Y",
                                    onChanged: (val) {
                                      // 안쓰는 val
                                      viewmodel.done(viewmodel.doneList[index]);
                                    },
                                  ),
                                  Text(viewmodel.doneList[index].content),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () => viewmodel.delete(viewmodel.doneList[index].idx),
                                  child: Icon(Icons.close))
                            ]);
                          },
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
