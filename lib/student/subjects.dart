import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'submissions.dart';
import 'dart:convert';
import 'classroom.dart';
import 'main.dart';
import 'profile.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

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
          'Classroom',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClassroomScreen()),
                  );
                },
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else if (snapshot.hasData) {
                      List<Map<String, dynamic>> data = snapshot.data!;
                      return StackedContainers(data: data);
                    }
                    return const Text("No data");
                  },
                ),
              ),
            ),
          ],
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
                          builder: (context) => const SubjectsScreen()),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder,
                        color: Color(0xFF0187F1),
                      ),
                      Text(
                        'Classroom',
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
                      MaterialPageRoute(
                          builder: (context) => const SubmissionsScreen()),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.featured_play_list),
                      Text(
                        'Submission',
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
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/poc_head/poc/fetch_poc.php'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}


class StackedContainers extends StatelessWidget {
  final List<Map<String, dynamic>>? data;
  const StackedContainers({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return data != null
        ? ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data!.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            ContainerItem(data: data![index]),
            const SizedBox(height: 10),
          ],
        );
      },
    )
        : const Center(child: Text('No data'));
  }
}

class ContainerItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const ContainerItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Elevated Container
            Container(
              width: 360.2,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            // Image with Text Overlay
            Positioned(
              bottom: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.asset(
                      'icons/bg-mobile-1.png',
                      width: 360,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Text(
                        data['subject'],
                        style: const TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 45,
                      child: Text(
                        data['subject_code'],
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 60,
                      child: Text(
                        data['name'],
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 15,
                          color: Colors.blue,
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
  }
}
