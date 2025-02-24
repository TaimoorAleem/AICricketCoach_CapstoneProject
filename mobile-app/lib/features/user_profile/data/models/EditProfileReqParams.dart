

class EditProfileReqParams {
  final String uid;
  final String age;
  final String city;
  final String country;
  final String teamName;
  final String description;
  final String firstName;
  final String lastName;
  EditProfileReqParams({required this.uid,required this.age, required this.city, required this.country, required this.teamName, required this.description, required this.firstName, required this.lastName
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid':uid,
      'age': age,
      'city': city,
      'country': country,
      'teamName': teamName,
      'description': description,
      'firstName': firstName,
      'lastName':lastName

    };
  }

}
