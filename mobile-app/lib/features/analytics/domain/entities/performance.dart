class Performance {
  final String date;
  final double averageAccuracy;
  final double averageExecutionRating;
  final double averageSpeed;

  Performance({
    required this.date,
    required this.averageAccuracy,
    required this.averageExecutionRating,
    required this.averageSpeed,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      date: json["date"],
      averageAccuracy: json["performance"][0]["averageAccuracy"].toDouble(),
      averageExecutionRating: json["performance"][0]["averageExecutionRating"].toDouble(),
      averageSpeed: json["performance"][0]["averageSpeed"].toDouble(),
    );
  }
}
