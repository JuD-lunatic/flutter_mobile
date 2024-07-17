import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'add_subjects.dart';
import 'edit_subject.dart';
import 'main.dart';
import 'profile.dart';

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
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ImplementingSubjectsScreen()),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.manage_accounts,
                        color: Color(0xFF0187F1),
                      ),
                      Text(
                        'Manage Subjects',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0187F1),
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
                          builder: (context) => const ProfileScreen()),
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
  final List<String> programs;
  final List<int> yearLevels;

  Subject({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.programs,
    required this.yearLevels,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      subjectName: json['subject_name'] ?? '',
      subjectCode: json['subject_code'] ?? '',
      programs: List<String>.from(json['programs'] ?? []),
      yearLevels: List<int>.from(json['year_levels'] ?? []),
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
          // Filter subjects to include only those with "Associate in Computer Technology"
          _subjects = _subjects.where((subject) => subject.programs.contains('Associate in Computer Technology')).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load subjects, status code: ${response.statusCode}');
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

  Future<void> _selectSubject(Subject subject) async {
    const url = 'http://localhost/poc_head/subjects/add_pending_subject.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'subject_id': subject.id,
          'subject_name': subject.subjectName,
          'subject_code': subject.subjectCode,
          'program': 'Associate in Computer Technology',
          'year_level': subject.yearLevels.isNotEmpty ? subject.yearLevels.first : 0,
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject selected successfully')),
        );
      } else {
        throw Exception('Failed to select subject');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select subject. Error: $e')),
      );
    }
  }

  Map<int, Map<String, List<Subject>>> _groupSubjectsByYearLevelAndProgram(List<Subject> subjects) {
    Map<int, Map<String, List<Subject>>> groupedSubjects = {};
    for (var subject in subjects) {
      for (var yearLevel in subject.yearLevels) {
        if (!groupedSubjects.containsKey(yearLevel)) {
          groupedSubjects[yearLevel] = {};
        }
        for (var program in subject.programs) {
          if (!groupedSubjects[yearLevel]!.containsKey(program)) {
            groupedSubjects[yearLevel]![program] = [];
          }
          groupedSubjects[yearLevel]![program]!.add(subject);
        }
      }
    }
    return groupedSubjects;
  }

  @override
  Widget build(BuildContext context) {
    final groupedSubjects = _groupSubjectsByYearLevelAndProgram(_subjects);

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupedSubjects.keys.length,
              itemBuilder: (context, index) {
                final yearLevel = groupedSubjects.keys.elementAt(index);
                final programs = groupedSubjects[yearLevel]!;

                return ExpansionTile(
                  title: Text(
                    'Year Level $yearLevel',
                    style: const TextStyle(
                      fontFamily: 'Poppins-SemiBold',
                    ),
                  ),
                  children: programs.keys.map((program) {
                    final subjects = programs[program]!;
                    return ExpansionTile(
                      title: Text(
                        program,
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                      children: subjects.map((subject) {
                        return ListTile(
                          title: Text(
                            subject.subjectName,
                            style: const TextStyle(
                              fontFamily: 'Poppins-SemiBold',
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                style: const TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                ),
                                'Course Code: ${subject.subjectCode}'
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditSubjectsScreen(
                                        subjectId: int.tryParse(subject.id) ?? 0,
                                        subjectName: subject.subjectName,
                                        subjectCode: subject.subjectCode,
                                        programs: subject.programs,
                                        yearLevels: subject.yearLevels,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteSubject(subject.id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  _selectSubject(subject);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
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

  Future<void> sendDataToBackend(
      List<List<dynamic>> data, BuildContext context) async {
    Uri uri = Uri.parse('http://localhost/poc_head/subjects/import_subjects.php');
    try {
      List<Map<String, dynamic>> jsonList = data.map((list) {
        return {
          'subject_name': list[0],
          'subject_code': list[1],
          'program': list[2],
          'year_level': list[3],
        };
      }).toList();

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonList),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subjects successfully uploaded')));
      } else {
        throw Exception('Failed to upload data, status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
                MaterialPageRoute(
                    builder: (context) => const AddSubjectsScreen()),
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
