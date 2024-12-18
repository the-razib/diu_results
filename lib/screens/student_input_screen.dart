import 'package:flutter/material.dart';

class StudentInputScreen extends StatelessWidget {
  final TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:AppBar(
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

            // CGPA Calculator Screen with SgpaCalculator
            Center(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text('SgpaCalculator Screen (Future feature)',
                    textAlign: TextAlign.center),
              ),
            ),
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
