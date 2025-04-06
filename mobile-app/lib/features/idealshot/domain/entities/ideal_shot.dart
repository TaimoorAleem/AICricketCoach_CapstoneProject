class IdealShot {
  final String shot;
  final double confidenceScore;

  IdealShot({
    required this.shot,
    required this.confidenceScore,
  });

  factory IdealShot.fromJson(Map<String, dynamic> json) {
    return IdealShot(
      shot: json['shot'],
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }
}