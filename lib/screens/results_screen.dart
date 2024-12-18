import 'package:diu_result/model/result.dart';
import 'package:diu_result/model/semester.dart';
import 'package:diu_result/model/student_info.dart';
import 'package:diu_result/services/api_service.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String studentId =
    ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: FutureBuilder<StudentInfo?>(
        future: apiService.getStudentInfo(studentId),
        builder: (context, studentInfoSnapshot) {
          if (studentInfoSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (studentInfoSnapshot.hasError ||
              studentInfoSnapshot.data == null) {
            return Center(
                child: Text('Error fetching student info.',
                    style: TextStyle(color: Colors.red)));
          }

          final studentInfo = studentInfoSnapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display student information and CGPA
                buildInfoSection(studentInfo),
                SizedBox(height: 20),
                buildCGPACard(context, studentInfo),

                SizedBox(height: 20),

                // Fetch and display semesters with results
                Expanded(
                  child: FutureBuilder<List<Semester>?>(
                    future: apiService.getSemesterList(),
                    builder: (context, semesterSnapshot) {
                      if (semesterSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (semesterSnapshot.hasError ||
                          semesterSnapshot.data == null) {
                        return const Center(
                            child: Text('Error fetching semester list.'));
                      }

                      final semesters = semesterSnapshot.data!;

                      return ListView.builder(
                        itemCount: semesters.length,
                        itemBuilder: (context, index) {
                          final semester = semesters[index];

                          return FutureBuilder<List<Result>?>(
                            future: apiService.getResultForSemester(
                                studentId, semester.semesterId),
                            builder: (context, resultSnapshot) {
                              if (resultSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(); // Skip loading indicator
                              }

                              if (resultSnapshot.hasError ||
                                  resultSnapshot.data == null ||
                                  resultSnapshot.data!.isEmpty) {
                                return SizedBox(); // Skip semesters with no results
                              }

                              final results = resultSnapshot.data!;
                              final semesterGpa = _calculateSGPA(results);

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // Semester Header with SGPA
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${semester.semesterName} ${semester.semesterYear}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'SGPA: ${semesterGpa.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      // Results
                                      ...results.map((result) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      result.courseTitle,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                        'Course ID: ${result.customCourseId}'),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Grade: ${result.gradeLetter}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                      'Credits: ${result.totalCredit}'),
                                                  Text(
                                                      'CGPA: ${result.pointEquivalent.toStringAsFixed(2)}'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
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

  // Helper method to build student information section
  Widget buildInfoSection(StudentInfo studentInfo) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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

  // Helper method to build the CGPA card
  Widget buildCGPACard(BuildContext context, StudentInfo studentInfo) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Final CGPA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Text(
                //   studentInfo.cgpa.toStringAsFixed(2),
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 28,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to calculate SGPA for a semester
  double _calculateSGPA(List<Result> results) {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var result in results) {
      totalPoints += result.pointEquivalent * result.totalCredit;
      totalCredits += result.totalCredit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}