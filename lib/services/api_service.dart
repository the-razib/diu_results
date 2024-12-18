import 'dart:convert';
import 'package:diu_result/model/result.dart';
import 'package:diu_result/model/semester.dart';
import 'package:diu_result/model/student_info.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://software.diu.edu.bd:8006';

class ApiService {
  Future<StudentInfo?> getStudentInfo(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/result/studentInfo?studentId=$studentId'));

    if (response.statusCode == 200) {
      return StudentInfo.fromJson(json.decode(response.body));
    }
    return null;
  }

  Future<List<Semester>?> getSemesterList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/result/semesterList'));

      if (response.statusCode == 200) {
        Iterable jsonList = json.decode(response.body);
        return jsonList.map((e) => Semester.fromJson(e)).toList();
      } else {
        print('Failed to fetch semester list. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching semester list: $e');
      return null;
    }
  }


  Future<List<Result>?> getResultForSemester(String studentId, String semesterId) async {
    final response = await http.get(Uri.parse('$baseUrl/result?studentId=$studentId&semesterId=$semesterId'));

    if (response.statusCode == 200) {
      Iterable jsonList = json.decode(response.body);
      return jsonList.map((e) => Result.fromJson(e)).toList();
    }
    return null;
  }
}
