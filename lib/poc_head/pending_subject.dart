import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'assign_subject.dart';

class PendingSubject {
  final int id;
  final int subjectId;
  final String subjectName;
  final String subjectCode;
  final String program;
  final int yearLevel;

  PendingSubject({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.program,
    required this.yearLevel,
  });

  factory PendingSubject.fromJson(Map<String, dynamic> json) {
    return PendingSubject(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      subjectId: json['subject_id'] is int ? json['subject_id'] as int : int.tryParse(json['subject_id'].toString()) ?? 0,
      subjectName: json['subject_name'] as String,
      subjectCode: json['subject_code'] as String,
      program: json['program'] as String,
      yearLevel: json['year_level'] is int ? json['year_level'] as int : int.tryParse(json['year_level'].toString()) ?? 0,
    );
  }
}

Future<List<PendingSubject>> fetchPendingSubjects() async {
  final response = await http.get(Uri.parse('http://localhost/poc_head/subjects/fetch_pending_subjects.php'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => PendingSubject.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load pending subjects');
  }
}

Future<void> approveSubject(int id) async {
  print('Approving subject with ID: $id'); // Debug print
  final response = await http.post(
    Uri.parse('http://localhost/poc_head/subjects/approve_subject.php'),
    body: jsonEncode({'id': id}),
    headers: {'Content-Type': 'application/json'},
  );

  print('Approve response status: ${response.statusCode}'); // Debug print
  print('Approve response body: ${response.body}'); // Debug print

  if (response.statusCode == 200) {
    print('Subject approved successfully');
  } else {
    throw Exception('Failed to approve subject');
  }
}

Future<void> denySubject(int id) async {
  print('Denying subject with ID: $id'); // Debug print
  final response = await http.post(
    Uri.parse('http://localhost/poc_head/subjects/deny_subject.php'),
    body: jsonEncode({'id': id}),
    headers: {'Content-Type': 'application/json'},
  );

  print('Deny response status: ${response.statusCode}'); // Debug print
  print('Deny response body: ${response.body}'); // Debug print

  if (response.statusCode == 200) {
    print('Subject denied successfully');
  } else {
    throw Exception('Failed to deny subject');
  }
}


// PendingSubjectTile Widget
class PendingSubjectTile extends StatelessWidget {
  final PendingSubject subject;
  final Function(int) onApprove;
  final Function(int) onDeny;

  const PendingSubjectTile({super.key, 
    required this.subject,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(subject.subjectName),
      children: <Widget>[
        ListTile(
          title: Text('Subject Code: ${subject.subjectCode}'),
        ),
        ListTile(
          title: Text('Program: ${subject.program}'),
        ),
        ListTile(
          title: Text('Year Level: ${subject.yearLevel}'),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print('Approve button pressed for subject ID: ${subject.id}');
                  onApprove(subject.id);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Approve'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print('Deny button pressed for subject ID: ${subject.id}');
                  onDeny(subject.id);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Deny'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// PendingSubjectsScreen Widget
class PendingSubjectsScreen extends StatefulWidget {
  const PendingSubjectsScreen({super.key});

  @override
  _PendingSubjectsScreenState createState() => _PendingSubjectsScreenState();
}

class _PendingSubjectsScreenState extends State<PendingSubjectsScreen> {
  Future<List<PendingSubject>>? _pendingSubjects;

  @override
  void initState() {
    super.initState();
    _pendingSubjects = fetchPendingSubjects();
  }

  void _approveSubject(int id) async {
    try {
      await approveSubject(id);
      setState(() {
        _pendingSubjects = fetchPendingSubjects();
      });
    } catch (e) {
      print('Error approving subject: $e');
    }
  }

  void _denySubject(int id) async {
    try {
      await denySubject(id);
      setState(() {
        _pendingSubjects = fetchPendingSubjects();
      });
    } catch (e) {
      print('Error denying subject: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AssignSubjectScreen()),
            );
          },
        ),
        title: const Text(
          'Pending\nRequests',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<PendingSubject>>(
        future: _pendingSubjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending subjects available.'));
          } else {
            return ListView(
              children: snapshot.data!.map((subject) => PendingSubjectTile(
                subject: subject,
                onApprove: _approveSubject,
                onDeny: _denySubject,
              )).toList(),
            );
          }
        },
      ),
    );
  }
}
