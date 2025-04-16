class PlayerEntity {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? teamName;
  final String? age;
  final String? city;
  final String? country;
  final String? description;
  final String? pfpUrl;

  PlayerEntity({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.teamName,
    this.age,
    this.city,
    this.country,
    this.description,
    this.pfpUrl,
  });
}
