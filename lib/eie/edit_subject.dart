import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditSubjectScreen extends StatelessWidget {
  final int subjectId;
  final String subjectName;
  final String subjectCode;
  final String program;
  final int yearLevel;

  const EditSubjectScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.program,
    required this.yearLevel,
  });

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
          'Edit Subject',
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
          child: EditSubjectForm(
            subjectId: subjectId,
            subjectName: subjectName,
            subjectCode: subjectCode,
            program: program,
            yearLevel: yearLevel,
          ),
        ),
      ),
    );
  }
}

class EditSubjectForm extends StatefulWidget {
  final int subjectId;
  final String subjectName;
  final String subjectCode;
  final String program;
  final int yearLevel;

  const EditSubjectForm({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.program,
    required this.yearLevel,
  });

  @override
  _EditSubjectFormState createState() => _EditSubjectFormState();
}

class _EditSubjectFormState extends State<EditSubjectForm> {
  late TextEditingController _subjectNameController;
  late TextEditingController _subjectCodeController;
  String _selectedProgramName = '';
  int _selectedYearLevelValue = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _subjectNameController = TextEditingController(text: widget.subjectName);
    _subjectCodeController = TextEditingController(text: widget.subjectCode);
    _selectedProgramName = widget.program;
    _selectedYearLevelValue = widget.yearLevel;
  }

  void _editSubject() {
    _submitForm();
  }

  Future<void> _confirmAndEditSubject() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Changes'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to save these changes?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _editSubject();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (!_isFormValid()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var url = 'http://localhost/poc_head/subjects/update_subject.php';
      var body = {
        'subject_id': widget.subjectId.toString(),
        'subject_name': _subjectNameController.text,
        'subject_code': _subjectCodeController.text,
        'program': _selectedProgramName,
        'year_level': _selectedYearLevelValue.toString(),
      };

      var response = await http.post(Uri.parse(url), body: body);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update subject. Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subject. Error: $e')),
      );
    }
  }

  bool _isFormValid() {
    return _selectedProgramName.isNotEmpty &&
        _selectedYearLevelValue > 0 &&
        _subjectNameController.text.isNotEmpty &&
        _subjectCodeController.text.isNotEmpty;
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
          'Program',
          style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: 16,
          ),
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          child: DropdownButtonFormField<String>(
            value: _selectedProgramName,
            onChanged: (newValue) {
              setState(() {
                _selectedProgramName = newValue!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: 'Associate in Computer Technology',
                child: Text(
                  'Associate in Computer Technology',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Bachelor of Library and Information Science',
                child: Text(
                  'Bachelor of Library and Information Science',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Bachelor of Science in Information Technology',
                child: Text(
                  'Bachelor of Science in Information Technology',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Bachelor of Science in Computer Science',
                child: Text(
                  'Bachelor of Science in Computer Science',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0187F1)),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              suffixIcon: ImageIcon(
                AssetImage('icons/down-button.png'),
                color: Color(0xFF0187F1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Year Level',
          style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: 16,
          ),
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          child: DropdownButtonFormField<int>(
            value: _selectedYearLevelValue,
            onChanged: (newValue) {
              setState(() {
                _selectedYearLevelValue = newValue!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: 1,
                child: Text(
                  '1st Year',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text(
                  '2nd Year',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text(
                  '3rd Year',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 4,
                child: Text(
                  '4th Year',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              // Add other year levels if needed
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0187F1)),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              suffixIcon: ImageIcon(
                AssetImage('icons/down-button.png'),
                color: Color(0xFF0187F1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _confirmAndEditSubject,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0187F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF0089F6)),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
                : const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

