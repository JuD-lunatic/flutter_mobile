import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReAssigningPage extends StatefulWidget {
  final String id;

  const ReAssigningPage({super.key, required this.id});

  @override
  _ReAssigningPageState createState() => _ReAssigningPageState();
}

class _ReAssigningPageState extends State<ReAssigningPage> {
  String? _selectedCollegePOC;
  String? _selectedCollegePOCEmail;
  List<Map<String, String>> _collegePOCList = [];
  bool isLoadingPOCs = true;

  @override
  void initState() {
    super.initState();
    fetchCollegePOCs();
  }

  Future<void> fetchCollegePOCs() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost/college_poc/display_contacts.php'));
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

  Future<void> reAssignSubject() async {
    if (_selectedCollegePOC != null && _selectedCollegePOCEmail != null) {
      final Map<String, String> body = {
        'id': widget.id,
        'new_poc_name': _selectedCollegePOC!,
        'new_email': _selectedCollegePOCEmail!,
      };
      print('Sending data: $body'); // Print the data being sent

      final response = await http.post(
        Uri.parse('http://localhost/college_poc/reassign_subject.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Subject reassigned successfully!')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to reassign subject.')));
        }
      } else {
        print(
            'Server error: ${response.body}'); // Print the server error message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Server error: Failed to reassign subject.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a new POC.')));
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
          'Re-Assigning',
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
                'Select New College POC',
                style: GoogleFonts.getFont(
                  'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF383838),
                ),
              ),
              const SizedBox(height: 10),
              isLoadingPOCs
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      value: _selectedCollegePOC,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      hint: const Text('Select New College POC'),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCollegePOC = newValue;
                          _selectedCollegePOCEmail = _collegePOCList.firstWhere(
                              (poc) => poc['poc_name'] == newValue)['email'];
                        });
                      },
                      items: _collegePOCList.map<DropdownMenuItem<String>>(
                          (Map<String, String> poc) {
                        return DropdownMenuItem<String>(
                          value: poc['poc_name'],
                          child: Text(poc['poc_name']!),
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
                    child: const Text('Cancel',
                        style: TextStyle(color: Color(0xFF0187F1))),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: reAssignSubject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0187F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Re-Assign',
                        style: TextStyle(color: Colors.white)),
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
