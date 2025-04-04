import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/entities/user_entity.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_profile.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:ai_cricket_coach/resources/app_navigator.dart';
import 'package:ai_cricket_coach/resources/display_message.dart';
import 'package:ai_cricket_coach/resources/service_locator.dart';
import 'package:ai_cricket_coach/features/user_profile/data/models/EditProfileReqParams.dart';
import 'package:reactive_button/reactive_button.dart';

import '../../domain/usecases/edit_pfp_usecase.dart';

class EditUserProfilePage extends StatefulWidget {
  final UserEntity user;
  final String pfpPath;

  EditUserProfilePage({super.key, required this.user, required this.pfpPath});

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  late String _pfpPath;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _ageCon = TextEditingController();
  final TextEditingController _teamNameCon = TextEditingController();
  final TextEditingController _cityCon = TextEditingController();
  final TextEditingController _countryCon = TextEditingController();
  final TextEditingController _descriptionCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pfpPath = widget.pfpPath;
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    bool? confirm = await _showConfirmationDialog(image.path);

    if (confirm == true) {
      setState(() {
        _pfpPath = image.path;
      });

      await sl<EditPFPUseCase>().call(params: image.path);

    }
  }

  Future<bool?> _showConfirmationDialog(String imagePath) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Do you want to update your profile picture?"),
              const SizedBox(height: 10),
              Image.file(File(imagePath), height: 100),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [const SizedBox(height: 30), editForm(context)],
        ),
      ),
    );
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
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Choose from Gallery"),
                    onTap: () {
                      Navigator.pop(context); // Close modal
                      _pickImage(ImageSource.gallery); // Open gallery
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Take a Photo"),
                    onTap: () {
                      Navigator.pop(context); // Close modal
                      _pickImage(ImageSource.camera); // Open camera
                    },
                  ),
                ],
              );
            },
          );
        },
        child: CircleAvatar(
          radius: 30,
          backgroundImage: _pfpPath.isNotEmpty
              ? FileImage(File(_pfpPath)) as ImageProvider
              : const AssetImage('lib/images/default-pfp.jpg'),
        )

    );
  }


  Widget _firstNameField() {
    return TextField(
      controller: _firstNameCon,
      decoration: InputDecoration(
        hintText: widget.user.firstName,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _lastNameField() {
    return TextField(
      controller: _lastNameCon,
      decoration: InputDecoration(
        hintText: widget.user.lastName,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _teamNameField() {
    return TextField(
      controller: _teamNameCon,
      decoration: InputDecoration(
        hintText: widget.user.teamName,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _ageField() {
    return TextField(
      controller: _ageCon,
      decoration: InputDecoration(
        hintText: widget.user.age,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _cityField() {
    return TextField(
      controller: _cityCon,
      decoration: InputDecoration(
        hintText: widget.user.city,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _countryField() {
    return TextField(
      controller: _countryCon,
      decoration: InputDecoration(
        hintText: widget.user.country,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _descriptionField() {
    return TextField(
      controller: _descriptionCon,
      decoration: InputDecoration(
        hintText: widget.user.description,
        border: const OutlineInputBorder(),
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

  Future<String> _getUid() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    return sharedPreferences.getString('uid')!;
  }

  Widget _saveButton(BuildContext context) {
    return Center(
      child: ReactiveButton(
        title: 'Save changes',
        width: 10,
        height: 30,
        activeColor: AppColors.primary,
        onPressed: () async => sl<EditProfileUseCase>().call(
          params: EditProfileReqParams(
              uid: await _getUid(),
              age: _ageCon.text.isEmpty ? widget.user.age! : _ageCon.text,
              city: _cityCon.text.isEmpty ? widget.user.city! : _cityCon.text,
              country:
              _countryCon.text.isEmpty ? widget.user.country! : _countryCon.text,
              description: _descriptionCon.text.isEmpty
                  ? widget.user.description!
                  : _descriptionCon.text,
              firstName: _firstNameCon.text.isEmpty
                  ? widget.user.firstName!
                  : _firstNameCon.text,
              lastName: _lastNameCon.text.isEmpty
                  ? widget.user.lastName!
                  : _lastNameCon.text,
              teamName: _teamNameCon.text.isEmpty
                  ? widget.user.teamName!
                  : _teamNameCon.text),
        ),
        onSuccess: () {
          AppNavigator.pushAndRemove(context, UserProfilePage());
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        },
      ),
    );
  }
}