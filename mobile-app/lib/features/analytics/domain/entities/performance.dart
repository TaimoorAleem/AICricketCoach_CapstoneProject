class Performance {
  final String date;
  final double averageExecutionRating;
  final double averageSpeed;

  Performance({
    required this.date,
    required this.averageExecutionRating,
    required this.averageSpeed,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      date: json["date"],
      averageExecutionRating: json["performance"][0]["averageExecutionRating"].toDouble(),
      averageSpeed: json["performance"][0]["averageSpeed"].toDouble(),
    );
  }
}
