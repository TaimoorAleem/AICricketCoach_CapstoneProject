import 'package:ai_cricket_coach/features/user_profile/domain/entities/user_entity.dart';

import '../features/user_profile/data/models/user.dart';

class UserMapper{
  static UserEntity toEntity(UserModel user){
    return UserEntity(
        age: user.age,
        city: user.city,
        country: user.country,
        description: user.description,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        pfpUrl: user.pfpUrl,
        role: user.role,
        teamName: user.teamName,
        uid: user.uid);
  }
}