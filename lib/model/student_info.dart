class StudentInfo {
  final String studentName;
  final String studentId;
  final String programName;
  final String departmentName;
  final String campusName;

  StudentInfo({
    required this.studentName,
    required this.studentId,
    required this.programName,
    required this.departmentName,
    required this.campusName,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      studentName: json['studentName'],
      studentId: json['studentId'],
      programName: json['programName'],
      departmentName: json['departmentName'],
      campusName: json['campusName'],
    );
  }
}
