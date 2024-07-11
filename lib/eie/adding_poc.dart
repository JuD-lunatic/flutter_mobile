import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPOCScreen extends StatelessWidget {
  const AddPOCScreen({super.key});

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
          'College POC\nRegistration',
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
        child: RegistrationForm(),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedSubject;
  final List<String> _selectedPrograms = [];
  bool _isLoading = false;
  List<String> _subjects = [];
  bool _isSubjectsLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    const url = 'http://10.0.2.2/poc_head/subjects/fetch_subjects.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _subjects = List<String>.from(data);
          _isSubjectsLoading = false;
        });
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      setState(() {
        _isSubjectsLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load subjects. Error: $e')),
      );
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    var url = 'http://localhost/poc_head/poc/add_poc.php';
    var response = await http.post(Uri.parse(url), body: {
      'name': _nameController.text,
      'email': _emailController.text,
    });

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Data sent successfully');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data sent successfully')),
      );
    } else {
      if (kDebugMode) {
        print('Failed to send data. Error: ${response.reasonPhrase}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to send data. Error: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name',
            style: TextStyle(
              fontFamily: 'Poppins-SemiBold',
              fontSize: 16,
            ),
          ),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter Your Name',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0187F1)),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Email',
            style: TextStyle(
              fontFamily: 'Poppins-SemiBold',
              fontSize: 16,
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Enter Your Email',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0187F1)),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFF0089F6)),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF0089F6)),
                ),
              ),
              const SizedBox(height: 15, width: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _submitForm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0089F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
