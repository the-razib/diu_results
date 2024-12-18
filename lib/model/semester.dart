class Semester {
  final String semesterId;     // String from JSON
  final int semesterYear;      // int from JSON
  final String semesterName;   // String from JSON

  Semester({
    required this.semesterId,
    required this.semesterYear,
    required this.semesterName,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      semesterId: json['semesterId'],               // Directly as String
      semesterYear: json['semesterYear'],           // Directly as int
      semesterName: json['semesterName'],           // Directly as String
    );
  }
}
