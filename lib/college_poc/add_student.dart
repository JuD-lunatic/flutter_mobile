import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key});

  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _yearLevelController = TextEditingController();
  final TextEditingController _programController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addStudent() async {
    setState(() {
      _isLoading = true;
    });

    // Gather student data from form
    final String name = _nameController.text;
    final String number = _numberController.text;
    final int yearLevel = int.tryParse(_yearLevelController.text) ?? 0;
    final String program = _programController.text;

    const url = 'http://localhost/college_poc/add_student.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'name': name,
          'number': number,
          'year_level': yearLevel.toString(),
          'program': program,
        },
      );
      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully')),
        );
        // Clear form fields
        _nameController.clear();
        _numberController.clear();
        _yearLevelController.clear();
        _programController.clear();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add student. Error: ${response.body}')),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add student. Error: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            TextFormField(
              controller: _numberController,
              decoration: const InputDecoration(labelText: 'Student Number'),
            ),
            TextFormField(
              controller: _yearLevelController,
              decoration: const InputDecoration(labelText: 'Year Level'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _programController,
              decoration: const InputDecoration(labelText: 'Program'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addStudent,
              child: const Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _yearLevelController.dispose();
    _programController.dispose();
    super.dispose();
  }
}
