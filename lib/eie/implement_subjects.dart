import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'profile.dart';
import '../eie/add_subjects.dart';
import 'edit_subject.dart';
import 'main.dart';
import 'manage_poc.dart';

class ImplementingSubjectsScreen extends StatelessWidget {
  const ImplementingSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6CBCFB),
        toolbarHeight: 140,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Implementing\nSubjects',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        centerTitle: true,
      ),

      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 370,
                  child: ContainerManager(
                    children: [
                      ExpansionPanelWidget(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: ButtonsLayout(),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.dashboard,
                    ),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImplementingSubjectsScreen(),
                    ),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.subject,
                      color: Color(0xFF0187F1),
                    ),
                    Text(
                      'Implement Subjects',
                      style: TextStyle(
                        color: Color(0xFF0187F1),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CollegePOCManagementScreen(),
                    ),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.manage_accounts_sharp),
                    Text(
                      'Manage POC',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
  final String subjectName;
  final String subjectCode;
  final int yearLevel;
  final String program;

  Subject({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.yearLevel,
    required this.program,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      subjectName: json['subject_name'] ?? '',
      subjectCode: json['subject_code'] ?? '',
      yearLevel: int.parse(json['year_level'].toString()),
      program: json['program'] ?? '',
    );
  }
}

class ExpansionPanelWidget extends StatefulWidget {
  const ExpansionPanelWidget({super.key});

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
    const url = 'http://localhost/poc_head/subjects/get_subjects.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _subjects = data.map((json) => Subject.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load subjects');
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

  Future<void> _deleteSubject(String id) async {
    final url = 'http://localhost/poc_head/subjects/delete_subject.php?id=$id';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject deleted successfully')),
        );
        _fetchSubjects();
      } else {
        throw Exception('Failed to delete subject');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete subject. Error: $e')),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                title: Text(
                  subject.subjectName,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Course Code: ',
                              style: TextStyle(
                                fontFamily: 'Poppins-SemiBold',
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              subject.subjectCode,
                              style: const TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
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
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Action(s):',
                              style: TextStyle(
                                fontFamily: 'Poppins-SemiBold',
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditSubjectScreen(
                                      subjectId: int.tryParse(subject.id) ?? 0,
                                      subjectName: subject.subjectName,
                                      subjectCode: subject.subjectCode,
                                      program: subject.program,
                                      yearLevel: subject.yearLevel,
                                    ),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.edit, size: 20,),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                _deleteSubject(subject.id);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.delete, size: 20,),
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
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.black,
                      indent: 40.0,
                      endIndent: 40.0,
                    ),
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

  Future<void> importCSV(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      sendDataToBackend(fields, context);
    }
  }

  Future<void> sendDataToBackend(List<List<dynamic>> data, BuildContext context) async {
    Uri uri = Uri.parse('http://localhost/college_poc/importSubj.php');
    try {
      List<Map<String, dynamic>> jsonList = data.map((list) => {
        'id': list[0],
        'subject_name': list[1],
        'subject_code': list[2],
        'program': list[3],
        'year_level': list[4]
      }).toList();

      var response = await http.post(uri, body: {'data': jsonList.toString()});
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subjects successfully uploaded'))
        );
      } else {
        throw Exception('Failed to upload data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSubjectsScreen()),
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
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: () => importCSV(context),
            icon: const Icon(
              Icons.file_upload,
              color: Colors.white,
            ),
            label: const Text(
              'Import CSV',
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
