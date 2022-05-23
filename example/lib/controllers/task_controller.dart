import 'package:example/models/task.dart';
import 'package:get/get.dart';
import '../db/db.helper.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

  var taskList= <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }

  //데이터베이스 테이블에서 모든 데이터 값 가져오기
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }

  //동기화하는 이유는 업데이트 하는 데 시간이 필요할 수도 있음.
  void markTaskCompleted(int id) async{
    await DBHelper.update(id);
    getTasks();
  }

}