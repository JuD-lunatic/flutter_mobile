import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:main/student/view_evaluation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evaluation Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  Map<int, List<Subject>> _groupSubjectsByYearLevel(List<Subject> subjects) {
    Map<int, List<Subject>> groupedSubjects = {};
    for (var subject in subjects) {
      for (var program in subject.programs) {
        if (program == "Information Technology") {
          for (var yearLevel in subject.yearLevels) {
            if (!groupedSubjects.containsKey(yearLevel)) {
              groupedSubjects[yearLevel] = [];
            }
            groupedSubjects[yearLevel]!.add(subject);
          }
        }
      }
    }
    return groupedSubjects;
  }

  @override
  Widget build(BuildContext context) {
    final groupedSubjects = _groupSubjectsByYearLevel(_subjects);

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
                final subjects = groupedSubjects[yearLevel]!;

                return ExpansionTile(
                  title: Text(
                    'Year Level $yearLevel',
                    style: const TextStyle(
                      fontFamily: 'Poppins-SemiBold',
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
                          Text('Course Code: ${subject.subjectCode}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {

                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteSubject(subject.id);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          );
  }
}
