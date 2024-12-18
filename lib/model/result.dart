class Result {
  final String courseTitle;
  final String customCourseId;
  final String gradeLetter;
  final double totalCredit;
  final double pointEquivalent;

  Result({
    required this.courseTitle,
    required this.customCourseId,
    required this.gradeLetter,
    required this.totalCredit,
    required this.pointEquivalent,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      courseTitle: json['courseTitle'],
      customCourseId: json['customCourseId'],
      gradeLetter: json['gradeLetter'],
      totalCredit: double.parse(json['totalCredit'].toString()),
      pointEquivalent: double.parse(json['pointEquivalent'].toString()),
    );
  }
}
