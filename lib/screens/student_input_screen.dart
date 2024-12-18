import 'package:flutter/material.dart';

class StudentInputScreen extends StatelessWidget {
  final TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
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
            SingleChildScrollView(
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
                      decoration: InputDecoration(
                        labelText: 'Enter Student ID',
                        hintText: 'e.g., 201-15-3637',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),

                    // Action Button
                    ElevatedButton(
                      onPressed: () {
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                        elevation: 2,
                      ),
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
            ),

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
                child: const Text('SgpaCalculator Screen (Future feature)', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
