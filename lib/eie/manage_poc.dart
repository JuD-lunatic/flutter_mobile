import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'profile.dart';
import 'view_active_poc.dart';
import 'adding_poc.dart';
import 'edit_poc.dart';
import 'implement_subjects.dart';
import 'main.dart';
import 'package:file_picker/file_picker.dart';

class CollegePOCManagementScreen extends StatelessWidget {
  const CollegePOCManagementScreen({super.key});

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
          'POC\nManagement',
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
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 200),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ViewActivePOCScreen()),
                    );
                  },
                  child: const Text(
                    'View Active College POC',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 370,
                  child: ContainerManager(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(),
                        child: CollegePOCList(),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, right: 15),
                child: ButtonsLayout(),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.dashboard,
                    ),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImplementingSubjectsScreen(),
                    ),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.subject,
                    ),
                    Text(
                      'Implement Subjects',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CollegePOCManagementScreen(),
                    ),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.manage_accounts_sharp, color: Color(0xFF0187F1)),
                    Text(
                      'Manage POC',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0187F1),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 14,
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

class ContainerManager extends StatelessWidget {
  final List<Widget> children;

  const ContainerManager({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 370,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}



class CollegePOCList extends StatefulWidget {
  const CollegePOCList({super.key});

  @override
  _CollegePOCListState createState() => _CollegePOCListState();
}

class _CollegePOCListState extends State<CollegePOCList> {
  List<dynamic> pocData = [];

  Future<void> fetchPOCs() async {
    final response = await http.get(Uri.parse('http://localhost/college_poc/display_contacts.php'));

    if (response.statusCode == 200) {
      setState(() {
        pocData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPOCs();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pocData.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var poc = pocData[index];
        return ExpansionPanelWidget1(
          poc_name: poc['poc_name'],
          email: poc['email'],
          id: poc['id'].toString(),
          onDelete: () {
            // implement deletion
          },
          onEdit: () {
            // implement edit
          },
        );
      },
    );
  }
}

class ButtonsLayout extends StatelessWidget {
  const ButtonsLayout({super.key});

  Future<void> _pickAndUploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      var file = result.files.single;

      var uri = Uri.parse('http://localhost/college_poc/importPOC.php');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', file.path!));

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV File has been successfully Imported.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to import CSV file.')),
        );
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPOCScreen()),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0089F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: () {
              _pickAndUploadFile(context);
            },
            icon: const Icon(
              Icons.file_upload,
              color: Colors.white,
            ),
            label: const Text(
              'Import CSV',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0089F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpansionPanelWidget1 extends StatelessWidget {
  final String poc_name;
  final String email;
  final String id;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ExpansionPanelWidget1({
    super.key,
    required this.poc_name,
    required this.email,
    required this.id,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ListTile(
        title: ExpansionTile(
          title: Text(
            poc_name,
            style: const TextStyle(
              fontFamily: 'Poppins-SemiBold',
            ),
          ),
          leading: Image.asset(
            'icons/down-button.png',
            width: 30,
            height: 30,
            color: const Color(0xFF0187F1),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Name: ',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        poc_name,
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Email: ',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Action(s): ',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 10,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to EditPOCScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditPOCScreen(id: id,)),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 4),
                            Text('Edit', style: TextStyle(fontSize: 10, fontFamily: 'Poppins-Regular',)),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Implement delete action
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 20),
                            SizedBox(width: 4),
                            Text('Delete', style: TextStyle(fontSize: 10, fontFamily: 'Poppins-Regular',)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
