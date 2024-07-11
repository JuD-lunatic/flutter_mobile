import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ViewTaskScreen extends StatefulWidget {
  final dynamic task;

  const ViewTaskScreen({super.key, required this.task});

  @override
  _ViewTaskScreenState createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  bool workSubmitted = false;
  String submissionMessage = 'You have no work uploaded.';

  Future<void> submitWork(String type, String content, String description, {File? file}) async {
    try {
      var uri = Uri.parse('http://localhost/college_poc/submit_work.php');
      var request = http.MultipartRequest('POST', uri);

      request.fields['type'] = type;
      request.fields['task_id'] = widget.task['id'].toString();
      request.fields['title'] = widget.task['title'];
      request.fields['due_date'] = widget.task['due_date'];
      request.fields['due_time'] = widget.task['task_time'];
      request.fields['description'] = widget.task['description'];

      if (type == 'link') {
        request.fields['content'] = content;
      } else if (type == 'file' && file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var responseBody = jsonDecode(responseData.body);
        setState(() {
          workSubmitted = true;
          submissionMessage = responseBody['message'];
        });
      } else {
        throw Exception('Failed to submit work');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        submissionMessage = 'Error submitting work: $e';
      });
    }
  }



  void _onInsertLinkClick() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController linkController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();

        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(45, 33, 45, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 17),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Add Link',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: const Color(0xFF383838),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 34),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: TextField(
                    controller: linkController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                      hintText: 'Link',
                      hintStyle: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        color: const Color(0xFF959698),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(6.6, 0, 6.6, 0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 26.5, 0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                                color: const Color(0xFF0187F1),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            String link = linkController.text;
                            String description = descriptionController.text;
                            if (link.isNotEmpty) {
                              await submitWork('link', link, description);
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                submissionMessage = 'Link cannot be empty';
                              });
                            }
                          },
                          child: Text(
                            'Add',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 24,
                              color: const Color(0xFF383838),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDECEC),
        toolbarHeight: 100,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 150.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 33, 12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Due ${widget.task['due_date']} ${widget.task['task_time']}',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: const Color(0xFF383838),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 33, 12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.task['title'], // Task Title
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: const Color(0xFF0187F1),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 70),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFFFFF),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 4),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 22, 33, 27),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 22),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Instructions:',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: const Color(0xFF383838),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(11, 0, 0, 16),
                        child: Text(
                          widget.task['description'],
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            letterSpacing: -0.2,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Work',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: const Color(0xFF383838),
                  ),
                ),
                Text(
                  'Assigned',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: -0.3,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 30, 0, 15),
              child: Text(
                workSubmitted ? submissionMessage : 'You have no work uploaded.',
                style: GoogleFonts.getFont(
                  'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: -0.3,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              child: ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.link),
                  onPressed: _onInsertLinkClick,
                ),
                title: Text(
                  'Insert Link',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
