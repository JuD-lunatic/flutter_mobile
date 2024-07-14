import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'add_student.dart';
import 'class_management.dart';
import 'classroom_activities.dart';

class ClassroomStudentManagementScreen extends StatelessWidget {
  final String classId;

  const ClassroomStudentManagementScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    print("Navigated to Student Management with class ID: $classId");
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
                  MaterialPageRoute(builder: (context) => const ClassScreen()),
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
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchClassDetails(classId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No class details available'));
                } else {
                  var data = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, left: 0, right: 200, top: 0),
                        child: Text(
                          data['subject'] ?? 'No Subject',
                          style: const TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0187F1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, left: 0, right: 350, top: 0),
                        child: Text(
                          data['subject_code'] ?? 'No Code',
                          style: const TextStyle(
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 60, left: 0, right: 300, top: 0),
                        child: Text(
                          data['name'] ?? 'No Name',
                          style: const TextStyle(
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
                              print(
                                  "Navigating to Activities with class ID: $classId");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ClassroomActivityScreen(classId: classId),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 8, 0, 15),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),
                              child: const Text(
                                'Activities',
                                style: TextStyle(
                                  fontFamily: 'Poppins-SemiBold',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: Color(0xFF6B6D76),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 8, 0, 15),
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
                              padding: const EdgeInsets.fromLTRB(20, 9, 20, 9),
                              child: const Text(
                                '     Student\nManagement',
                                style: TextStyle(
                                  fontFamily: 'Poppins-SemiBold',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 370,
                  child: ContainerManager(
                    children: [
                      ExpansionPanelWidget(classId: classId),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: ButtonsLayout(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchClassDetails(String classId) async {
    final response = await http.get(Uri.parse(
        'http://localhost/college_poc/fetch_class_details.php?classId=$classId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load class details');
    }
  }
}

class ContainerManager extends StatelessWidget {
  final List<Widget> children;

  const ContainerManager({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 370,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class Subject {
  final String id;
  final String studentName;
  final String studentNumber;
  final int yearLevel;
  final String program;

  Subject({
    required this.id,
    required this.studentName,
    required this.studentNumber,
    required this.yearLevel,
    required this.program,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentNumber: json['student_number'] ?? '',
      yearLevel: int.tryParse(json['year_level']) ?? 0,
      program: json['program'] ?? '',
    );
  }
}

class ExpansionPanelWidget extends StatefulWidget {
  final String classId;
  const ExpansionPanelWidget({super.key, required this.classId});

  @override
  _ExpansionPanelWidgetState createState() => _ExpansionPanelWidgetState();
}

class _ExpansionPanelWidgetState extends State<ExpansionPanelWidget> {
  List<Subject> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    final url =
        'http://localhost/college_poc/fetch_students.php?classId=${widget.classId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _subjects = data.map((json) => Subject.fromJson(json)).toList();
          _isLoading = false;
        });
        // If no data is available, show a message
        if (_subjects.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("No Students"),
                content:
                    const Text("No Students Currently Enrolled to the Subject"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data. Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                return Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                        subject.studentName,
                        style: const TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                        ),
                      ),
                      leading: Image.asset(
                        'icons/down-button.png',
                        width: 30,
                        height: 30,
                        color: const Color(0xFF0187F1),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Student No: ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-SemiBold',
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  subject.studentNumber,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Year Level: ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-SemiBold',
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  subject.yearLevel.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Program: ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-SemiBold',
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  subject.program,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Action(s):',
                              style: TextStyle(
                                fontFamily: 'Poppins-SemiBold',
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Action for delete student
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1.0,
                          color: Colors.black,
                          indent: 30.0,
                          endIndent: 30.0,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
  }
}

class ButtonsLayout extends StatelessWidget {
  const ButtonsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Action for delete all students button
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Delete All',
              style: TextStyle(color: Color(0xFF0089F6)),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF0089F6)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentFormScreen()),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0089F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
