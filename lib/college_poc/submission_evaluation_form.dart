import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../student/view_evaluation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evaluation Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EvaluationFormScreen(),
    );
  }
}

class EvaluationFormScreen extends StatefulWidget {
  const EvaluationFormScreen({Key? key}) : super(key: key);

  @override
  _EvaluationFormScreenState createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends State<EvaluationFormScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isLoading = false;

  // Pronunciation subcategory state variables
  String? _selectedPronunciationConsistency;
  String? _selectedPronunciationArticulation;
  String? _selectedPronunciationClarity;
  String? _selectedPronunciationIntonationStress;

  // Grammar subcategory state variables
  String? _selectedGrammarAccuracy;
  String? _selectedGrammarClarityOfThought;
  String? _selectedGrammarSyntax;

  // Fluency subcategory state variables
  String? _selectedFluencyQualityOfResponse;
  String? _selectedFluencyDetailOfResponse;

  final List<String> _options = ['0.00', '0.50', '1.00', '1.50', '2.00', '2.50', '3.00', '4.00'];

  // Calculate average for a list of scores
// Calculate average for a list of scores
  double _calculateAverage(List<String?> scores) {
    double sum = 0.0;
    int count = 0;
    for (var score in scores) {
      if (score != null) {
        sum += double.parse(score);
        count++;
      }
    }
    // Handle the case where all scores are null (initialize to 0.0)
    return count == 0 ? 0.0 : sum / count;
  }


  // Determine EPGF descriptor based on average
  String _getEPGFDescriptor(double average) {
    if (average == 0.0) return 'Beginning';
    if (average == 0.50) return 'Low Acquisition';
    if (average == 0.75) return 'High Acquisition';
    if (average == 1.00) return 'Emerging';
    if (average == 1.25) return 'Low Developing';
    if (average == 1.50) return 'High Developing';
    if (average == 1.75) return 'Low Proficient';
    if (average == 2.00) return 'Proficient';
    if (average == 2.25) return 'High Proficient';
    if (average == 2.50) return 'Advanced';
    if (average == 3.00) return 'High Advanced';
    if (average == 4.00) return 'Native/Bilingual';
    return '';
  }

  // Determine CEFR and CEFR category based on average
  Map<String, String> _getCEFR(double average) {
    if (average >= 1.00 && average <= 1.49) return {'CEFR': 'A1', 'Category': 'BEGINNER'};
    if (average >= 1.50 && average <= 1.99) return {'CEFR': 'A2', 'Category': 'ELEMENTARY'};
    if (average >= 2.00 && average <= 2.49) return {'CEFR': 'B1', 'Category': 'INTERMEDIATE'};
    if (average >= 2.50 && average <= 2.99) return {'CEFR': 'B2', 'Category': 'UPPER INTERMEDIATE'};
    if (average >= 3.00 && average <= 3.99) return {'CEFR': 'C1', 'Category': 'PROFICIENT'};
    if (average == 4.00) return {'CEFR': 'C2', 'Category': 'ADVANCED / Native'};
    return {'CEFR': '', 'Category': ''};
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    // Calculate average for pronunciation
    double pronunciationAverage = _calculateAverage([
      _selectedPronunciationConsistency,
      _selectedPronunciationArticulation,
      _selectedPronunciationClarity,
      _selectedPronunciationIntonationStress,
    ]);

    // Calculate average for grammar
    double grammarAverage = _calculateAverage([
      _selectedGrammarAccuracy,
      _selectedGrammarClarityOfThought,
      _selectedGrammarSyntax,
    ]);

    // Calculate average for fluency
    double fluencyAverage = _calculateAverage([
      _selectedFluencyQualityOfResponse,
      _selectedFluencyDetailOfResponse,
    ]);

    // Calculate EPGF average
    double epgfAverage = _calculateAverage([
      pronunciationAverage.toString(),
      grammarAverage.toString(),
      fluencyAverage.toString(),
    ]);

    // Determine EPGF Descriptor
    String epgfDescriptor = _getEPGFDescriptor(epgfAverage);

    // Determine CEFR and CEFR Category
    Map<String, String> cefrData = _getCEFR(epgfAverage);

    var data = {
      'pronunciation_average': pronunciationAverage.toString(),
      'grammar_average': grammarAverage.toString(),
      'fluency_average': fluencyAverage.toString(),
      'epgf_average': epgfAverage.toString(),
      'feedback': _feedbackController.text,
      'epgf_descriptor': epgfDescriptor,
      'cefr': cefrData['CEFR'],
      'cefr_category': cefrData['Category'],
    };

    var url = 'http://localhost/college_poc/store_data.php';
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Handle success
      var responseData = jsonDecode(response.body);
      print(responseData['message']);

      // Navigate to EvaluationPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EvaluationPage()),
      );
    } else {
      // Handle error
      print('Error: ${response.reasonPhrase}');
    }

    setState(() {
      _isLoading = false;
    });

    // Clear the feedback controller after submission
    _feedbackController.clear();
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
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 70),
            Text(
              'Evaluation\n     Form',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontFamily: 'Montserrat-Bold',
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
          child: ContainerManager(
            children: [
              const EPGFScoreCard(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _FeedbackTextArea(
                  children: [
                    const Text(
                      'Feedback',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Enter your feedback here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Color(0xFF0187F1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Color(0xFF0187F1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Color(0xFF0187F1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ButtonRow(
                isLoading: _isLoading,
                submitForm: _submitForm,
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

class _FeedbackTextArea extends StatelessWidget {
  final List<Widget> children;

  const _FeedbackTextArea({required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(16.0),
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

class ButtonRow extends StatelessWidget {
  final bool isLoading;
  final VoidCallback submitForm; // Change the type here

  const ButtonRow({required this.isLoading, required this.submitForm});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFF0089F6)),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF0089F6)),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: isLoading ? null : submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0089F6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}


class EPGFScoreCard extends StatefulWidget {
  const EPGFScoreCard({Key? key}) : super(key: key);

  @override
  _EPGFScoreCardState createState() => _EPGFScoreCardState();
}

class _EPGFScoreCardState extends State<EPGFScoreCard> {
  // Pronunciation subcategory state variables
  String? _selectedPronunciationConsistency;
  String? _selectedPronunciationArticulation;
  String? _selectedPronunciationClarity;
  String? _selectedPronunciationIntonationStress;

  // Grammar subcategory state variables
  String? _selectedGrammarAccuracy;
  String? _selectedGrammarClarityOfThought;
  String? _selectedGrammarSyntax;

  // Fluency subcategory state variables
  String? _selectedFluencyQualityOfResponse;
  String? _selectedFluencyDetailOfResponse;

  final List<String> _options = ['0.00', '0.50', '1.00', '1.50', '2.00', '2.50', '3.00', '4.00'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'PRONUNCIATION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildExpansionTile(
            title: 'Consistency',
            groupValue: _selectedPronunciationConsistency,
            onChanged: (value) {
              setState(() {
                _selectedPronunciationConsistency = value;
              });
            },
          ),
          _buildExpansionTile(
            title: 'Articulation',
            groupValue: _selectedPronunciationArticulation,
            onChanged: (value) {
              setState(() {
                _selectedPronunciationArticulation = value;
              });
            },
          ),
          _buildExpansionTile(
            title: 'Clarity',
            groupValue: _selectedPronunciationClarity,
            onChanged: (value) {
              setState(() {
                _selectedPronunciationClarity = value;
              });
            },
          ),
          _buildExpansionTile(
            title: 'Intonation and Stress',
            groupValue: _selectedPronunciationIntonationStress,
            onChanged: (value) {
              setState(() {
                _selectedPronunciationIntonationStress = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'GRAMMAR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildExpansionTile(
            title: 'Accuracy',
            groupValue: _selectedGrammarAccuracy,
            onChanged: (value) {
              setState(() {
                _selectedGrammarAccuracy = value;
              });
            },
          ),
          _buildExpansionTile(
            title: 'Clarity of Thought',
            groupValue: _selectedGrammarClarityOfThought,
            onChanged: (value) {
              setState(() {
                _selectedGrammarClarityOfThought = value;
              });
            },
          ),
          _buildExpansionTile(
            title: 'Syntax',
            groupValue: _selectedGrammarSyntax,
            onChanged: (value) {
              setState(() {
                _selectedGrammarSyntax = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'FLUENCY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildExpansionTile(
            title: 'Quality of Response',
            groupValue: _selectedFluencyQualityOfResponse,
            onChanged: (value) {
              setState(() {
                _selectedFluencyQualityOfResponse = value;
              });
            },
          ),
          _buildExpansionTile(
            title: 'Detail of Response',
            groupValue: _selectedFluencyDetailOfResponse,
            onChanged: (value) {
              setState(() {
                _selectedFluencyDetailOfResponse = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        children: _options
            .map((option) => RadioListTile<String>(
          value: option,
          groupValue: groupValue,
          onChanged: onChanged,
          title: Text(option),
          controlAffinity: ListTileControlAffinity.trailing,
        ))
            .toList(),
      ),
    );
  }
}

