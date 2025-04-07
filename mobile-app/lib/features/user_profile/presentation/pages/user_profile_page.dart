import 'package:ai_cricket_coach/features/authentication/presentation/pages/log_in_page.dart';
import 'package:ai_cricket_coach/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:ai_cricket_coach/features/home/presentation/pages/home_page.dart';

import 'package:ai_cricket_coach/features/user_profile/presentation/widgets/user_profile.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../authentication/domain/usecases/logout_usecase.dart';
import '../../data/models/delete_account_params.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import 'edit_user_profile_page.dart';

class UserProfilePage extends StatelessWidget {
  UserProfilePage({super.key});

  final TextEditingController _passwordCon = TextEditingController();

  Future<String?> get_uid() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString('uid');
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [const UserProfile(), _allButtons(context)],
    ));
  }

  Widget _allButtons(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: _otherButtons(context),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: _otherButtons2(context),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: _logOutButton(context),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: _deleteButton(context),
            ),
          ],
        )
    );
  }

  Widget _otherButtons(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(
        Icons.settings,
        color: AppColors.primary,
      ),
      label: const Text(
        'Settings',
        style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito'),
      ),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        fixedSize: Size(220, 50),
        backgroundColor: AppColors.secondary, // Button background color
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  Widget _otherButtons2(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(
        Icons.file_open_sharp,
        color: AppColors.primary,
      ),
      label: const Text(
        'Terms and\nConditions',
        style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito'),
      ),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        fixedSize: Size(220, 68),
        backgroundColor: AppColors.secondary, // Button background color
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  Widget _logOutButton(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () async {
          // Make sure the dialog only runs if the context is still active
          if (!context.mounted) return;

          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to log out?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(false); // Cancel
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true); // Confirm
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );

          // Handle the user's decision
          if (shouldLogout == true && context.mounted) {
            final success = await sl<LogOutUseCase>().call();
            if (success && context.mounted) {
              AppNavigator.pushAndRemove(context, LogInPage());
            }
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(220, 50),
          backgroundColor: AppColors.secondary, // Button background color
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        icon: const Icon(Icons.logout, color: AppColors.primary),
        label: const Text(
          'Log Out',
          style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nunito'),
        ));
  }

  Widget _deleteButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Account",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      "Are you sure you want to delete your account? This action cannot be undone."),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordCon,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Enter password",
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String? uid = await get_uid();

                      // Check if UID is null
                      if (uid == null) {
                        DisplayMessage.errorMessage(
                            "User ID not found. Please log in again.", context);
                        return;
                      }

                      await sl<DeleteAccountUseCase>().call(
                        params: DeleteAccountReqParams(
                          uid: uid,
                          password: _passwordCon.text,
                        ),
                      );

                      // If successful, pop the dialog and navigate to LoginPage
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        AppNavigator.pushAndRemove(context, LogInPage());
                      }
                    } catch (error) {
                      DisplayMessage.errorMessage(error.toString(), context);
                    }
                  },
                  child: const Text("Confirm Delete"),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(220, 50),
        backgroundColor: AppColors.secondary, // Button background color
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      icon: const Icon(Icons.delete, color: AppColors.primary),
      label: const Text(
        "Delete Account",
        style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito'),
      ),
    );
  }
}
