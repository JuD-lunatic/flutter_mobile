import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../eie/data_fetcher.dart';
import 'main.dart';
import 'profile.dart';
import 'view_collegepocs.dart';
import 'view_impsubjects.dart';
import 'assign.dart';
import 'package:http/http.dart' as http;

class AssignSubjectScreen extends StatelessWidget {
  const AssignSubjectScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchAndMergeData() async {
    try {
      List<dynamic> data = await DataFetcher().fetchMergedData();

      if (data.isEmpty) {
        print('No data received');
        return [];
      }

      final uniqueData = data.cast<Map<String, dynamic>>().fold<List<Map<String, dynamic>>>([], (previousValue, element) {
        if (previousValue.any((e) => e['email'] == element['email'])) {
          return previousValue;
        } else {
          return [...previousValue, element];
        }
      });

      return uniqueData;
    } catch (e) {
      print('Error fetching and merging data: $e');
      return [];
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
          '             Assign \nImplementing Subject',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 25, 30, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ViewImplementingSubjectPage()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 9, 0),
                      child: SizedBox(
                        width: 200.8,
                        child: Text(
                          'View Implementing Subjects',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            letterSpacing: -0.2,
                            color: const Color(0xFF383838),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ViewCollegePocsPage()),
                      );
                    },
                    child: Text(
                      'View College POCs',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        letterSpacing: -0.2,
                        color: const Color(0xFF383838),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              const ActionButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
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
                      Icon(Icons.dashboard),
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
                          builder: (context) => const AssignSubjectScreen()),
                    );
                  },
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.class_rounded,
                          color: Color(0xFF0187F1),
                        ),
                        Text(
                          'Implementing Subjects',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0187F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
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
      ),
    );
  }
}
class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 20), // Add some spacing between the buttons
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AssigningPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0187F1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.group_add, color: Colors.white),
              SizedBox(width: 5),
              Text('Assign', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
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
  List<dynamic> pocs = []; // Initialize the list to avoid late initialization error
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPOCs();
  }

  Future<void> fetchPOCs() async {
    try {
      var url = 'http://localhost/poc_head/poc/fetch_poc.php';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        if (decodedJson is List) {
          setState(() {
            pocs = decodedJson;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception('Failed to load POCs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load POCs: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : pocs.isEmpty
        ? const Center(child: Text('No POCs found'))
        : Column(
      children: [
        for (var poc in pocs)
          ExpansionPanelWidget1(
            name: poc['name'] ?? 'No Name',
            subject: poc['subject'] ?? 'No Subject',
            email: poc['email'] ?? 'No Email',
            id: poc['id'] ?? '0',
            onDelete: () {
              _deletePOC(poc['id']);
            },
          ),
      ],
    );
  }

  Future<void> _deletePOC(String? id) async {
    try {
      var url = 'http://localhost/poc_head/poc/delete_poc.php';
      var response = await http.post(
        Uri.parse(url),
        body: {'id': id ?? ''},
      );

      if (response.statusCode == 200) {
        // Reload the POC list after deletion
        fetchPOCs();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('POC deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete POC: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete POC: $e')),
      );
    }
  }
}

class ExpansionPanelWidget1 extends StatelessWidget {
  final String name;
  final String subject;
  final String email;
  final String id;
  final VoidCallback onDelete;

  const ExpansionPanelWidget1({
    super.key,
    required this.name,
    required this.subject,
    required this.email,
    required this.id,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: ListTile(
          title: ExpansionTile(
            title: Text(
              name,
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
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
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
                          name,
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
                          'Assigned Subject: ',
                          style: TextStyle(
                            fontFamily: 'Poppins-SemiBold',
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          subject,
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
