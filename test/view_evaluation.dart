import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  _EvaluationPage createState() => _EvaluationPage();
}

class _EvaluationPage extends State<EvaluationPage> {
  bool isExpanded = false;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(18, 0, 18, 21),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Interaction Styles',
                    style: GoogleFonts.getFont(
                        'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: const Color(0xFF0187F1),
                    ),
                  ),
                ),
              ),
              ExpansionTile(
                collapsedBackgroundColor: Colors.white,
                title: Text(
                  'EPGF Average',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF383838),
                  ),
                ),
                trailing: Text(
                  '2.14',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pronunciation',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '2.25',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grammar',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '1.67',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fluency',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '2.5',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: Colors.black),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'CEFR',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'B2',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              'Category',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Upper Intermediate',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'EPGF Descriptor',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Proficient',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    'Feedback',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF383838),
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ),
              if (isExpanded)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Good Job!',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
