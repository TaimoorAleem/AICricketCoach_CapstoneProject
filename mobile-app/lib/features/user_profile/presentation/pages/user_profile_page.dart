import 'package:ai_cricket_coach/features/authentication/presentation/pages/log_in_page.dart';
import 'package:ai_cricket_coach/features/authentication/presentation/pages/sign_up_page.dart';

import 'package:ai_cricket_coach/features/user_profile/presentation/widgets/user_profile.dart';

import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../data/models/delete_account_params.dart';
import '../../domain/usecases/delete_account_usecase.dart';

class UserProfilePage extends StatelessWidget {
  UserProfilePage({super.key});

  final TextEditingController _passwordCon = TextEditingController();



  Future<String?> get_uid() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString('uid');
    return uid;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const UserProfile(),
                _deleteButton(context),
              ],
            )
        )
    );
  }

  Widget _deleteButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Account"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Are you sure you want to delete your account? This action cannot be undone."),
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
                        DisplayMessage.errorMessage("User ID not found. Please log in again.", context);
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
      child: const Text("Delete Account"),
    );
  }

}


