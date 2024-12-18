import 'package:diu_result/model/result.dart';
import 'package:diu_result/model/semester.dart';
import 'package:diu_result/model/student_info.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ResultsScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    final String studentId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Results', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<StudentInfo?>(
        future: apiService.getStudentInfo(studentId),
        builder: (context, studentInfoSnapshot) {
          if (studentInfoSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (studentInfoSnapshot.hasError || studentInfoSnapshot.data == null) {
            return Center(child: Text('Error fetching student info.', style: TextStyle(color: Colors.red)));
          }

          final studentInfo = studentInfoSnapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display student information
                buildStudentInfoSection(studentInfo),

                SizedBox(height: 20),

                // Fetch and display semesters with results
                Expanded(
                  child: FutureBuilder<List<Semester>?>(
                    future: apiService.getSemesterList(),
                    builder: (context, semesterSnapshot) {
                      if (semesterSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (semesterSnapshot.hasError || semesterSnapshot.data == null) {
                        return const Center(child: Text('Error fetching semester list.'));
                      }

                      final semesters = semesterSnapshot.data!;

                      return ListView.builder(
                        itemCount: semesters.length,
                        itemBuilder: (context, index) {
                          final semester = semesters[index];

                          return FutureBuilder<List<Result>?>(
                            future: apiService.getResultForSemester(studentId, semester.semesterId),
                            builder: (context, resultSnapshot) {
                              if (resultSnapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(); // Skip loading indicator
                              }

                              if (resultSnapshot.hasError || resultSnapshot.data == null || resultSnapshot.data!.isEmpty) {
                                return SizedBox(); // Skip semesters with no results
                              }

                              final results = resultSnapshot.data!;

                              return ExpansionTile(
                                leading: Icon(Icons.school, color: Colors.blueAccent),
                                title: Text(
                                  '${semester.semesterName} ${semester.semesterYear} (ID: ${semester.semesterId})',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                children: results.map((result) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          'Course: ${result.courseTitle} (${result.customCourseId})\n'
                                              'Grade: ${result.gradeLetter}, Credits: ${result.totalCredit}, CGPA: ${result.pointEquivalent.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // A method to build student info section
  Widget buildStudentInfoSection(StudentInfo studentInfo) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoRow('Name:', studentInfo.studentName),
            buildInfoRow('ID:', studentInfo.studentId),
            buildInfoRow('Program:', studentInfo.programName),
            buildInfoRow('Department:', studentInfo.departmentName),
            buildInfoRow('Campus:', studentInfo.campusName),
          ],
        ),
      ),
    );
  }

  // Helper method to create an info row
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
