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
    // Extract performance list safely
    List<dynamic>? performanceList = json["performance"];

    // If performance list is empty or missing, use default values
    var performanceData = (performanceList != null && performanceList.isNotEmpty)
        ? performanceList[0]
        : {"averageAccuracy": 0.0, "averageExecutionRating": 0.0, "averageSpeed": 0.0};

    return Performance(
      date: json["date"],
      averageAccuracy: (performanceData["averageAccuracy"] ?? 0.0).toDouble(),
      averageExecutionRating: (performanceData["averageExecutionRating"] ?? 0.0).toDouble(),
      averageSpeed: (performanceData["averageSpeed"] ?? 0.0).toDouble(),
    );
  }
}
