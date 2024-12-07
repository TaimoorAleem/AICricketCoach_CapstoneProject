import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wqeqwewq/features/authentication/presentation/pages/log_in_page.dart';
import 'package:wqeqwewq/features/user_profile/presentation/pages/user_profile_page.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../user_profile/presentation/pages/edit_user_profile_page.dart';
import '../../data/models/editprofile_req_params.dart';
import '../../domain/usecases/edit_profile_usecase.dart';


class EditUserProfilePage extends StatelessWidget {
  EditUserProfilePage({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        centerTitle: true,
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Save logic
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // _profilePictureSection(context),
              const SizedBox(height: 20),
              _textField('First Name', _firstNameController),
              const SizedBox(height: 10),
              _textField('Last Name', _lastNameController),
              const SizedBox(height: 10),
              _textField('Team Name', _teamNameController),
              const SizedBox(height: 10),
              _textField('Age', _ageController, keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _textField('Role', _roleController),
              const SizedBox(height: 10),
              _textField('City', _cityController),
              const SizedBox(height: 10),
              _textField('Country', _countryController),
              const SizedBox(height: 10),
              _textField('Description', _descriptionController, maxLines: 3),
            ],
          ),
        ),
      ),
    );
  }

  // Future<Widget> _profilePictureSection(BuildContext context) async {
  //
  //   return Stack(
  //     alignment: Alignment.bottomRight,
  //     children: [
  //       CircleAvatar(
  //         radius: 50,
  //         backgroundImage: pfpUrl != null && pfpUrl.isNotEmpty
  //             ? NetworkImage(pfpUrl)
  //             : const AssetImage('assets/default_profile.png') as ImageProvider,
  //       ),
  //       Positioned(
  //         bottom: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () {
  //             // Logic to edit profile picture
  //           },
  //           child: const CircleAvatar(
  //             backgroundColor: Colors.blue,
  //             radius: 18,
  //             child: Icon(Icons.edit, color: Colors.white, size: 20),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _textField(String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return ReactiveButton(
        title: 'Save',
        activeColor: AppColors.primary,
        onPressed: () async => sl < EditProfileUseCase > ().call(
          params: EditProfileReqParams(
            firstName : _firstNameController.text,
            lastName: _lastNameController.text,
            teamName: _teamNameController.text,
            age: _ageController.text,
            city: _cityController.text,
            country: _countryController.text,
            description: _descriptionController.text,
            role: _roleController.text
          ),
        ),
        onSuccess: () {
          AppNavigator.pushAndRemove(context, const UserProfilePage());
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        }
    );
  }
}




