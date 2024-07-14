import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'view_task.dart';
import 'class_management.dart';
import 'classroom_student_management.dart';
import 'create_task.dart';
import 'edit_task.dart';

class ClassroomActivityScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? data;
  const ClassroomActivityScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(330.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClassScreen(),
                  ),
                );
              },
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('icons/bg-mobile-1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(bottom: 5, left: 30, right: 15, top: 0),
                  child: Text(
                    'APPLICATION DEVELOPMENT',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0187F1),
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(bottom: 5, left: 0, right: 275, top: 0),
                  child: Text(
                    'BIT321k',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(bottom: 60, left: 0, right: 160, top: 0),
                  child: Text(
                    'Danny Boy Casimero',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0187F1),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ClassroomActivityScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF0187F1),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              offset: Offset(0, 4),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: const Text(
                          'Activities',
                          style: TextStyle(
                            fontFamily: 'Poppins-SemiBold',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ClassroomStudentManagementScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: const Text(
                          '     Student\nManagement',
                          style: TextStyle(
                            fontFamily: 'Poppins-SemiBold',
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Color(0xFF6B6D76),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 200, top: 15),
              child: AddTaskButton(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: ActiveTask(),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http
        .get(Uri.parse('http://localhost/poc_head/poc/fetch_poc.php'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class ActiveTask extends StatefulWidget {
  const ActiveTask({super.key});

  @override
  _ActiveTaskState createState() => _ActiveTaskState();
}

class _ActiveTaskState extends State<ActiveTask> {
  late Future<List<dynamic>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = fetchTasks();
  }

  Future<List<dynamic>> fetchTasks() async {
    final response =
        await http.get(Uri.parse('http://localhost/college_poc/get_tasks.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final url = Uri.parse('http://localhost/college_poc/delete_task.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': taskId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          setState(() {
            tasksFuture = fetchTasks();
          });
          print('Task deleted successfully');
        } else {
          print('Failed to delete task: ${responseBody['message']}');
        }
      } else {
        print('Network error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget buildTaskCard(BuildContext context, dynamic task) {
    return SizedBox(
      width: 350, // You can adjust this value as needed
      height: 100,
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewTaskScreen(task: task),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.task,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['title'] ?? 'No Task',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5D7285),
                                    fontSize: 18,
                                    fontFamily: 'Montserrat-Bold',
                                  ),
                                ),
                                Text(
                                  'Due: ${task['due_date']} ${task['task_time']}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Montserrat-Regular',
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      final int taskId = int.parse(task['id']);
                      final DateTime dueDate = DateTime.parse(task['due_date']);
                      final TimeOfDay taskTime = TimeOfDay(
                        hour: int.parse(task['task_time'].split(':')[0]),
                        minute: int.parse(task['task_time'].split(':')[1]),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(
                            taskId: taskId,
                            title: task['title'],
                            description: task['description'],
                            dueDate: dueDate,
                            taskTime: taskTime,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit ',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontFamily: 'Montserrat-Regular'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      final int taskId = int.parse(task['id']);
                      deleteTask(taskId);
                    },
                    child: const Text(
                      ' Delete',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontFamily: 'Montserrat-Regular'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No tasks available');
        } else {
          return Column(
            children: snapshot.data!
                .map((task) => buildTaskCard(context, task))
                .toList(),
          );
        }
      },
    );
  }
}

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewTaskScreen(),
          ),
        );
      },
      icon: const Icon(
        Icons.add_circle_outline,
        color: Colors.white,
      ),
      label: const Text(
        'Add New Task',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins-SemiBold',
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0187F1),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        textStyle: const TextStyle(fontSize: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ClassroomActivityScreen(),
  ));
}
