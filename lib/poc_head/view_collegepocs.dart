import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class ViewCollegePocsPage extends StatelessWidget {
  const ViewCollegePocsPage({super.key});

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
          'College POCs',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Align(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}