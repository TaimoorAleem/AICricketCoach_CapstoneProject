class UserModel {
  UserModel({
    required this.age,
    required this.city,
    required this.country,
    required this.description,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.pfpUrl,
    required this.role,
    required this.teamName,
    required this.uid,
  });

  final String? age;
  final String? city;
  final String? country;
  final String? description;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? pfpUrl;
  final String? role;
  final String? teamName;
  final String? uid;

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      age: json["age"],
      city: json["city"],
      country: json["country"],
      description: json["description"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      pfpUrl: json["pfpUrl"],
      role: json["role"],
      teamName: json["teamName"],
      uid: json["uid"],
    );
  }


}