import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditTaskScreen extends StatefulWidget {
  final int taskId;
  final String title;
  final String description;
  final DateTime dueDate;
  final TimeOfDay taskTime;

  const EditTaskScreen({
    required this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.taskTime,
    super.key,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedTaskTime;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDueDate = widget.dueDate;
    _selectedTaskTime = widget.taskTime;
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _selectTaskTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTaskTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTaskTime) {
      setState(() {
        _selectedTaskTime = picked;
      });
    }
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _onUpdate() async {
    final url = Uri.parse('http://10.0.2.2/college_poc/edit_task.php');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': widget.taskId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'due_date': _selectedDueDate?.toIso8601String(),
        'task_time': _selectedTaskTime?.format(context),
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update task: ${responseBody['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: ${response.statusCode}')),
      );
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
          'Edit Task',
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
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(6, 32, 20, 7),
                child: Text(
                  'Title',
                  style: GoogleFonts.getFont(
                    'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    letterSpacing: -0.3,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 15, 15),
                decoration: const BoxDecoration(
                  color: Color(0xCCFFFFFF),
                  border: Border(
                    left: BorderSide(
                      color: Color(0xFF0187F1),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter your title here',
                      hintStyle: GoogleFonts.getFont(
                        'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        letterSpacing: -0.3,
                        color: const Color(0x33000000),
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(6, 0, 20, 7),
                child: Text(
                  'Description',
                  style: GoogleFonts.getFont(
                    'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    letterSpacing: -0.3,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 15, 25),
                decoration: const BoxDecoration(
                  color: Color(0xCCFFFFFF),
                  border: Border(
                    left: BorderSide(
                      color: Color(0xFF0187F1),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter your description here',
                      hintStyle: GoogleFonts.getFont(
                        'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        letterSpacing: -0.3,
                        color: const Color(0x33000000),
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDueDate(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due Date',
                            style: GoogleFonts.getFont(
                              'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              letterSpacing: -0.3,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xCCFFFFFF),
                              border: Border.all(
                                color: const Color(0xFF0187F1),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _selectedDueDate == null
                                  ? 'Select Date'
                                  : '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}',
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                letterSpacing: -0.3,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTaskTime(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Task Time',
                            style: GoogleFonts.getFont(
                              'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              letterSpacing: -0.3,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xCCFFFFFF),
                              border: Border.all(
                                color: const Color(0xFF0187F1),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _selectedTaskTime == null
                                  ? 'Select Time'
                                  : _selectedTaskTime!.format(context),
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                letterSpacing: -0.3,
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
              Container(
                margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _onCancel,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF0187F1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: -0.3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: _onUpdate,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF0187F1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Update',
                              style: GoogleFonts.getFont(
                                'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: -0.3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
