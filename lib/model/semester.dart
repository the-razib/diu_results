class Semester {
  final String semesterId;
  final int semesterYear;
  final String semesterName;

  Semester({
    required this.semesterId,
    required this.semesterYear,
    required this.semesterName,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      semesterId: json['semesterId'],
      semesterYear: json['semesterYear'],
      semesterName: json['semesterName'],
    );
  }
}
