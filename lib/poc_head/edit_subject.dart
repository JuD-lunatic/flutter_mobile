import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditSubjectsScreen extends StatelessWidget {
  final int subjectId;
  final String subjectName;
  final String subjectCode;
  final List<String> programs;
  final List<int> yearLevels;

  const EditSubjectsScreen({
    Key? key,
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.programs,
    required this.yearLevels,
  }) : super(key: key);

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
          'Edit\nSubjects',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: EditForm(
            subjectId: subjectId,
            subjectName: subjectName,
            subjectCode: subjectCode,
            programs: programs,
            yearLevels: yearLevels,
          ),
        ),
      ),
    );
  }
}

class EditForm extends StatefulWidget {
  final int subjectId;
  final String subjectName;
  final String subjectCode;
  final List<String> programs;
  final List<int> yearLevels;

  const EditForm({
    Key? key,
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.programs,
    required this.yearLevels,
  }) : super(key: key);

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  late TextEditingController _subjectNameController;
  late TextEditingController _subjectCodeController;
  final Map<String, String> _programMap = {
    'Bachelor of Science in Computer Science': 'Computer Science',
    'Bachelor of Science in Information Technology': 'Information Technology',
    'Associate in Computer Technology': 'Associate in Computer Technology',
    'Bachelor of Library and Information Science': 'Library and Information Science',
  };
  late List<String> _selectedPrograms;
  late List<int> _selectedYearLevels;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _subjectNameController = TextEditingController(text: widget.subjectName);
    _subjectCodeController = TextEditingController(text: widget.subjectCode);
    _selectedPrograms = List.from(widget.programs);
    _selectedYearLevels = List.from(widget.yearLevels);
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var url = 'http://localhost/poc_head/subjects/update_subject.php';
      var body = json.encode({
        'subject_id': widget.subjectId.toString(),
        'subject_name': _subjectNameController.text,
        'subject_code': _subjectCodeController.text,
        'program': _selectedPrograms.map((program) => _programMap[program]).toList(),
        'year_level': _selectedYearLevels,
      });

      print('Sending data: $body');

      var response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to update data. Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update data. Error: $e')),
      );
    }
  }

  void _onProgramChanged(bool? value, String program) {
    setState(() {
      if (value == true) {
        _selectedPrograms.add(program);
      } else {
        _selectedPrograms.remove(program);
      }
    });
  }

  void _onYearLevelChanged(bool? value, int yearLevel) {
    setState(() {
      if (value == true) {
        _selectedYearLevels.add(yearLevel);
      } else {
        _selectedYearLevels.remove(yearLevel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject Name',
          style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: 16,
          ),
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          child: TextFormField(
            controller: _subjectNameController,
            decoration: const InputDecoration(
              hintText: 'Enter Subject Name',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0187F1)),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Subject Code',
          style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: 16,
          ),
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          child: TextFormField(
            controller: _subjectCodeController,
            decoration: const InputDecoration(
              hintText: 'Enter Subject Code',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0187F1)),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Programs',
          style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: 16,
          ),
        ),
        Column(
          children: _programMap.keys.map((program) {
            return CheckboxListTile(
              title: Text(program),
              value: _selectedPrograms.contains(program),
              onChanged: (value) => _onProgramChanged(value, program),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
        const Text(
          'Year Levels',
          style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: 16,
          ),
        ),
        Column(
          children: [
            CheckboxListTile(
              title: const Text('1st Year'),
              value: _selectedYearLevels.contains(1),
              onChanged: (value) => _onYearLevelChanged(value, 1),
            ),
            CheckboxListTile(
              title: const Text('2nd Year'),
              value: _selectedYearLevels.contains(2),
              onChanged: (value) => _onYearLevelChanged(value, 2),
            ),
            CheckboxListTile(
              title: const Text('3rd Year'),
              value: _selectedYearLevels.contains(3),
              onChanged: (value) => _onYearLevelChanged(value, 3),
            ),
            CheckboxListTile(
              title: const Text('4th Year'),
              value: _selectedYearLevels.contains(4),
              onChanged: (value) => _onYearLevelChanged(value, 4),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red, backgroundColor: Colors.white),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF0089F6)),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submitForm,
              icon: const Icon(
                Icons.update,
                color: Colors.white,
              ),
              label: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0089F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
