class Player {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String teamName;
  final String role;
  final String city;
  final String country;
  final String description;
  final String pfpUrl;

  Player({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.teamName,
    required this.role,
    required this.city,
    required this.country,
    required this.description,
    required this.pfpUrl,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      uid: json["uid"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      teamName: json["teamName"] ?? "No Team",
      role: json["role"],
      city: json["city"],
      country: json["country"],
      description: json["description"] ?? "",
      pfpUrl: json["pfpUrl"] ?? "",
    );
  }
}
