class AddDeliveryDTO {
  final String uid;
  final String sessionId;
  final String videoUrl;
  final String ballLength;
  final String ballLine;
  final int batsmanPosition;
  final double ballSpeed;
  final List<Map<String, dynamic>> predictedIdealShots;

  AddDeliveryDTO({
    required this.uid,
    required this.sessionId,
    required this.videoUrl,
    required this.ballLength,
    required this.ballLine,
    required this.batsmanPosition,
    required this.ballSpeed,
    required this.predictedIdealShots,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'sessionId': sessionId,
      'delivery': {
        'ballCharacteristics': {
          'ballLength': ballLength,
          'ballLine': ballLine,
          'batsmanPosition': batsmanPosition,
          'ballSpeed': ballSpeed,
        },
        'idealShot': {
          'predicted_ideal_shots': predictedIdealShots,
        },
        'videoUrl': videoUrl,
      },
    };
  }
}
