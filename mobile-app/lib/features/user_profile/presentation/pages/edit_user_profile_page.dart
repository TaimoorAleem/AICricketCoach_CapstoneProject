
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
  final _formKey = GlobalKey<FormState>();
  late String _pfpPath;
  late bool _isFormValid;
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
    _isFormValid = false;
  }

  @override
  void dispose() {
    _ageCon.dispose();
    _firstNameCon.dispose();
    _lastNameCon.dispose();
    _descriptionCon.dispose();
    _teamNameCon.dispose();
    _countryCon.dispose();
    _cityCon.dispose();
    super.dispose();
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _homeBar(context),
              const SizedBox(height: 10),
              _nameLabels(),
              _names(),
              const SizedBox(height: 40),
              _locationLabels(),
              _location(),
              const SizedBox(height: 40),
              _teamAndAgeLabels(),
              _teamAndAge(),
              const SizedBox(height: 40),
              _fieldLabel('Description'),
              _descriptionField(),
              const SizedBox(height: 30),
              if (_isFormValid) ...[
                _saveButton(context),
              ]
            ],
          ),
        ));
  }

  Widget _homeBar(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
            ),
            onPressed: () {
              // Replace with your actual home navigation logic
              AppNavigator.pushAndRemove(context, UserProfilePage());
            },
            color: AppColors.background,
            focusColor: AppColors.background,
            hoverColor: AppColors.background,
            highlightColor: AppColors.background,
            splashColor: AppColors.background,
          ),
          _validateButton(context)
        ],
      ) 
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
        ));
  }

  Widget _names() {
    return Row(
      children: [
        _pfp(),
        SizedBox(width: 10),
        Expanded(child: _firstNameField()),
        SizedBox(width: 8), // Optional: space between the fields
        Expanded(child: _lastNameField()),
      ],
    );
  }

  Widget _nameLabels() {
    return Row(
      children: [
        Align(child: _fieldLabel('Profile\nPicture\n')),
        SizedBox(width: 15),
        Expanded(child: _fieldLabel('First Name')),
        SizedBox(width: 8), // Optional: space between the fields
        Expanded(child: _fieldLabel('Last Name')),
      ],
    );
  }

  Widget _location() {
    return Row(
      children: [
        Expanded(child: _cityField()),
        SizedBox(width: 8), // Optional: space between the fields
        Expanded(child: _countryField()),
      ],
    );
  }

  Widget _locationLabels() {
    return Row(
      children: [
        Expanded(child: _fieldLabel('City')),
        SizedBox(width: 8), // Optional: space between the fields
        Expanded(child: _fieldLabel('Country')),
      ],
    );
  }

  Widget _teamAndAge() {
    return Row(
      children: [
        Expanded(child: _teamNameField()),
        SizedBox(width: 8), // Optional: space between the fields
        Expanded(child: _ageField()),
      ],
    );
  }

  Widget _teamAndAgeLabels() {
    return Row(
      children: [
        Expanded(child: _fieldLabel('Team')),
        SizedBox(width: 8), // Optional: space between the fields
        Expanded(child: _fieldLabel('Age')),
      ],
    );
  }

  Widget _firstNameField() {
    return TextField(
      controller: _firstNameCon,
      decoration: InputDecoration(
        hintText: widget.user.firstName,
        hintStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
    );
  }

  Widget _lastNameField() {
    return TextField(
      controller: _lastNameCon,
      decoration: InputDecoration(
        hintText: widget.user.lastName,
        hintStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
    );
  }

  Widget _teamNameField() {
    return TextFormField(
      controller: _teamNameCon,
      decoration: InputDecoration(
        hintText: widget.user.teamName,
        hintStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
      validator: (value){
        if(value==null || value.isEmpty){
          return null;
        }
        if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value!)) {
          return 'Team name can only contain letters, numbers, and spaces';
        }
        return null;
      },
    );
  }

  Widget _ageField() {
    return TextFormField(
      controller: _ageCon,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: widget.user.age,
        hintStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
      validator: (value) {
        // If value is empty, treat it as unchanged
        if (value == null || value.trim().isEmpty) {
          return null;
        }

        // If user entered same age as existing
        if (value.trim() == widget.user.age) {
          return null;
        }
        if (int.tryParse(value.trim()) == null) {
          return 'Please enter a valid number';
        }
        if (int.tryParse(value.trim())! < 13 ||
            int.tryParse(value.trim())! > 100) {
          return 'Age must be between 13 and 100';
        }
        return null;
      },
    );
  }

  Widget _cityField() {
    return TextField(
      controller: _cityCon,
      decoration: InputDecoration(
        hintText: widget.user.city,
        hintStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
    );
  }

  Widget _countryField() {
    return TextField(
      controller: _countryCon,
      decoration: InputDecoration(
        hintText: widget.user.country,
        hintStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
    );
  }

  Widget _descriptionField() {
    return TextField(
      controller: _descriptionCon,
      decoration: InputDecoration(
        hintText: widget.user.description,
        hintStyle: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Nunito',
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

  Widget _validateButton(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.check, // The tick icon
          color: _isFormValid
              ? AppColors.primary
              : Colors.grey,
        ),
        onPressed: () {
          // Only validate when the form is not yet validated
          if (!_isFormValid) {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isFormValid =
                    true; // Show tick icon after successful validation
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Form is valid!")),
              );
            }
          }
        });
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
              country: _countryCon.text.isEmpty
                  ? widget.user.country!
                  : _countryCon.text,
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
