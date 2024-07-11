import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssigningPage extends StatefulWidget {
  const AssigningPage({super.key});

  @override
  _AssigningPageState createState() => _AssigningPageState();
}

class _AssigningPageState extends State<AssigningPage> {
  String? _selectedCollegePOC;
  String? _assignedSubject;
  String? _selectedCollegePOCEmail;
  List<Map<String, String>> _collegePOCList = [];
  List<String> _subjectsList = [];
  bool isLoadingPOCs = true;
  bool isLoadingSubjects = true;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    fetchCollegePOCs();
  }

  Future<void> fetchSubjects() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/poc_head/subjects/get_subjects.php'));
      if (response.statusCode == 200) {
        final List<dynamic> subjectsData = json.decode(response.body);
        setState(() {
          _subjectsList = subjectsData.map((item) => item['subject_name'].toString()).toList();
          isLoadingSubjects = false;
        });
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoadingSubjects = false;
      });
    }
  }

  Future<void> fetchCollegePOCs() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/college_poc/display_contacts.php'));
      if (response.statusCode == 200) {
        final List<dynamic> pocsData = json.decode(response.body);
        setState(() {
          _collegePOCList = pocsData.map((item) {
            return {
              'poc_name': item['poc_name'].toString(),
              'email': item['email'].toString(),
            };
          }).toList();
          isLoadingPOCs = false;
        });
      } else {
        throw Exception('Failed to load College POCs');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoadingPOCs = false;
      });
    }
  }

  Future<void> assignSubject() async {
    if (_selectedCollegePOC != null && _assignedSubject != null && _selectedCollegePOCEmail != null) {
      final Map<String, String> body = {
        'poc_name': _selectedCollegePOC!,
        'email': _selectedCollegePOCEmail!,
        'subject_name': _assignedSubject!,
      };
      print('Sending data: $body'); // Print the data being sent

      final response = await http.post(
        Uri.parse('http://localhost/college_poc/assign_subject.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Subject assigned successfully!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to assign subject.')));
        }
      } else {
        print('Server error: ${response.body}'); // Print the server error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server error: Failed to assign subject.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select both POC and Subject.')));
    }
  }

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
          'Assigning',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select College POC',
                style: GoogleFonts.getFont(
                  'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF383838),
                ),
              ),
              const SizedBox(height: 10),
              isLoadingPOCs
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                value: _selectedCollegePOC,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                hint: const Text('Select College POC'),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCollegePOC = newValue;
                    _selectedCollegePOCEmail = _collegePOCList
                        .firstWhere((poc) => poc['poc_name'] == newValue)['email'];
                  });
                },
                items: _collegePOCList.map<DropdownMenuItem<String>>((Map<String, String> poc) {
                  return DropdownMenuItem<String>(
                    value: poc['poc_name'],
                    child: Text(poc['poc_name']!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 60),
              Text(
                'Assign Subject',
                style: GoogleFonts.getFont(
                  'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF383838),
                ),
              ),
              const SizedBox(height: 10),
              isLoadingSubjects
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                value: _assignedSubject,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                hint: const Text('Select Subject'),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    _assignedSubject = newValue;
                  });
                },
                items: _subjectsList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0187F1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF0187F1))),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: assignSubject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0187F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Assign', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
