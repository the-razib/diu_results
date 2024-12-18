import 'package:flutter/material.dart';

class StudentInputScreen extends StatelessWidget {
  final TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 18,
          bottom: const TabBar(
            indicatorWeight: 4.0,
            tabs: [
              Tab(
                icon: Icon(Icons.school, size: 32),
                text: 'Results',
              ),
              Tab(
                icon: Icon(Icons.calculate, size: 32),
                text: 'CGPA Calculator',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Results Screen
            resultScreenTabView(context),

            // CGPA Calculator Screen
            CGPACalculator(),
          ],
        ),
      ),
    );
  }

  // Result Screen Tab View
  Widget resultScreenTabView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Section
            const Icon(
              Icons.school,
              size: 100,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to the DIU Result Portal!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 24),

            // Input Field
            TextField(
              controller: studentIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Student ID',
                hintText: 'e.g., 201-15-3637',
                prefixIcon: Icon(Icons.person, color: Colors.black54),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 24),

            // Action Button
            ElevatedButton(
              onPressed: () {
                _onTabResultView(context);
              },
              child: const Text(
                'View Results',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabResultView(context) {
    final studentId = studentIdController.text.trim();
    if (studentId.isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/results',
        arguments: studentId,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Student ID'),
        ),
      );
    }
  }
}

// ------------------ Reuse the CGPACalculator ------------------

class CGPACalculator extends StatefulWidget {
  @override
  State<CGPACalculator> createState() => _CGPACalculatorState();
}

class _CGPACalculatorState extends State<CGPACalculator> {
  final List<Map<String, dynamic>> subjects = [
    {'name': '', 'grade': null, 'credit': 0},
    {'name': '', 'grade': null, 'credit': 0},
  ];

  void addSubject() {
    setState(() {
      subjects.add({'name': '', 'grade': null, 'credit': 0});
    });
  }

  void removeSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  double calculateCGPA() {
    double totalCredits = 0;
    double totalPoints = 0;

    for (var subject in subjects) {
      final gradePoint = subject['grade'] ?? 0.0;
      final credit = subject['credit'] ?? 0.0;
      totalCredits += credit;
      totalPoints += gradePoint * credit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'CGPA: ${calculateCGPA().toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return SubjectRow(
                  index: index,
                  subject: subjects[index],
                  onRemove: removeSubject,
                  onUpdate: (updatedSubject) {
                    setState(() {
                      subjects[index] = updatedSubject;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: addSubject,
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              label: const Text('Add Subject', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectRow extends StatefulWidget {
  final int index;
  final Map<String, dynamic> subject;
  final void Function(int) onRemove;
  final void Function(Map<String, dynamic>) onUpdate;

  const SubjectRow({
    required this.index,
    required this.subject,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  State<SubjectRow> createState() => _SubjectRowState();
}

class _SubjectRowState extends State<SubjectRow> {
  final List<Map<String, dynamic>> gradeOptions = [
    {'label': 'A+', 'point': 4.0},
    {'label': 'A', 'point': 3.75},
    {'label': 'A-', 'point': 3.50},
    {'label': 'B+', 'point': 3.25},
    {'label': 'B', 'point': 3.00},
    {'label': 'B-', 'point': 2.75},
    {'label': 'C+', 'point': 2.50},
    {'label': 'C', 'point': 2.25},
    {'label': 'D', 'point': 2.00},
    {'label': 'F', 'point': 0.00},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Name Field
            Row(
              children: [
                const Icon(Icons.book, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.subject['name'],
                    decoration: InputDecoration(
                      labelText: 'Subject ${widget.index + 1}',
                      hintText: 'Enter Subject Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      widget.subject['name'] = value;
                      widget.onUpdate(widget.subject);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grade and Credit Row
            Row(
              children: [
                // Grade Dropdown
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Grade',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField(
                        value: widget.subject['grade'],
                        decoration: InputDecoration(
                          hintText: 'Select Grade',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                        items: gradeOptions
                            .map(
                              (grade) => DropdownMenuItem(
                            value: grade['point'],
                            child: Text(grade['label']),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          widget.subject['grade'] = value;
                          widget.onUpdate(widget.subject);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Credit Field
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Credit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: widget.subject['credit'].toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter Credit',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          widget.subject['credit'] =
                              double.tryParse(value) ?? 0.0;
                          widget.onUpdate(widget.subject);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Delete Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => widget.onRemove(widget.index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text(
                  'Remove',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
