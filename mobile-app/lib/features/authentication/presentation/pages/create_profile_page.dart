import 'dart:io';

import 'package:ai_cricket_coach/features/home/presentation/pages/home_page.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/entities/user_entity.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_profile.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/app_theme.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../user_profile/data/models/EditProfileReqParams.dart';
import '../../domain/usecases/create_profile.dart';

class CreateProfilePage extends StatelessWidget {
  late final String pfpPath;

  CreateProfilePage({super.key, this.pfpPath = ""});

  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _ageCon = TextEditingController();
  final TextEditingController _teamNameCon = TextEditingController();
  final TextEditingController _cityCon = TextEditingController();
  final TextEditingController _countryCon = TextEditingController();
  final TextEditingController _descriptionCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [const SizedBox(height: 30), editForm(context)],
    )));
  }

  Widget editForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Profile picture'),
          _pfp(),
          const SizedBox(height: 30),
          _fieldLabel('First Name'),
          _firstNameField(),
          const SizedBox(height: 20),
          _fieldLabel('Last Name'),
          _lastNameField(),
          const SizedBox(height: 5),
          const SizedBox(height: 20),
          _fieldLabel('Age'),
          _ageField(),
          _fieldLabel('City'),
          _cityField(),
          _fieldLabel('Country'),
          _countryField(),
          _fieldLabel('Team Name'),
          _teamNameField(),
          _fieldLabel('Description'),
          _descriptionField(),
          const SizedBox(height: 5),
          const SizedBox(height: 30),
          _saveButton(context),
        ],
      ),
    );
  }

  Widget _pfp() {
    return const CircleAvatar(
      radius: 30, // Larger profile image
      backgroundImage: AssetImage('lib/images/default-pfp.jpg'), // Fallback
    );
  }

  Widget _firstNameField() {
    return TextField(
      controller: _firstNameCon,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _lastNameField() {
    return TextField(
      controller: _lastNameCon,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _teamNameField() {
    return TextField(
      controller: _teamNameCon,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _ageField() {
    return TextField(
      controller: _ageCon,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _cityField() {
    return TextField(
      controller: _cityCon,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _countryField() {
    return TextField(
      controller: _countryCon,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _descriptionField() {
    return TextField(
      controller: _descriptionCon,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future<String?> _getUid() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString('uid');
  }

  Widget _saveButton(BuildContext context) {
    return Center(
      child: ReactiveButton(
        title: 'Save',
        width: 10,
        height: 30,
        activeColor: AppColors.primary,
        onPressed: () async {
          var uid = await _getUid();
          await sl<CreateProfileUseCase>().call(
            params: EditProfileReqParams(
                uid:uid!,
                age: _ageCon.text,
                city: _cityCon.text,
                country: _countryCon.text,
                teamName: _teamNameCon.text,
                description: _descriptionCon.text,
                firstName: _firstNameCon.text,
                lastName: _lastNameCon.text
            ),
          );
        },
        onSuccess: () async {
          AppNavigator.pushAndRemove(context, UserProfilePage());
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        },
      ),
    );
  }

}
