import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view_submit_graded.dart';

class ViewTaskScreen extends StatefulWidget {
  final dynamic task;

  const ViewTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _ViewTaskScreenState createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  List submissions = [];

  @override
  void initState() {
    super.initState();
    fetchSubmissions();
  }

  fetchSubmissions() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2/college_poc/fetch_submissions.php'));

    if (response.statusCode == 200) {
      setState(() {
        submissions = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load submissions');
    }
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
            Navigator.pop(context);
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
                    'Due ${widget.task['due_date']} ${widget.task['task_time']}', // task due date and time
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
                          // Task Description
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
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          height: 300,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Submissions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF0187F1),
                ),
              ),
              const SizedBox(
                  height: 10), // Adding some space between text and buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: submissions.map((submission) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewSubmitGradedScreen(submission: submission),
                        ),
                      );
                    },
                    child: ContainerManager(submission: submission),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerManager extends StatefulWidget {
  final dynamic submission;

  const ContainerManager({super.key, required this.submission});

  @override
  _ContainerManagerState createState() => _ContainerManagerState();
}

class _ContainerManagerState extends State<ContainerManager> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ViewSubmitGradedScreen(submission: widget.submission),
          ),
        );
      },
      child: Container(
        width: 300,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F5),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [],
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.task,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Christine Joy Cleofe',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'On Time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
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
