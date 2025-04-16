import 'package:ai_cricket_coach/features/authentication/presentation/pages/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../authentication/domain/usecases/logout_usecase.dart';
import '../../data/models/delete_account_params.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../widgets/user_profile.dart';

class UserProfilePage extends StatelessWidget {
  UserProfilePage({super.key});

  final TextEditingController _passwordCon = TextEditingController();

  Future<String?> getUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              const UserProfile(),
              const SizedBox(height: 20),
              _allButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildButton(
            icon: Icons.settings,
            label: 'Settings',
            onPressed: () {},
            textColor: AppColors.primary,
          ),
          const SizedBox(height: 20),
          _buildButton(
            icon: Icons.file_open_sharp,
            label: 'Terms and Conditions',
            height: 68,
            onPressed: () {},
            textColor: AppColors.primary,
          ),
          const SizedBox(height: 20),
          _buildButton(
            icon: Icons.logout,
            label: 'Log Out',
            onPressed: () => _confirmLogout(context),
            textColor: Colors.orange,
          ),
          const SizedBox(height: 20),
          _buildButton(
            icon: Icons.delete,
            label: 'Delete Account',
            onPressed: () => _confirmDelete(context),
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color textColor,
    double height = 50,
  }) {
    return SizedBox(
      height: height,
      width: 220,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Confirm", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      final success = await sl<LogOutUseCase>().call();
      if (success && context.mounted) {
        AppNavigator.pushAndRemove(context, LogInPage());
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account",
            style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final uid = await getUid();

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

                if (context.mounted) {
                  Navigator.of(context).pop();
                  AppNavigator.pushAndRemove(context, LogInPage());
                }
              } catch (e) {
                DisplayMessage.errorMessage(e.toString(), context);
              }
            },
            child: const Text("Confirm Delete"),
          ),
        ],
      ),
    );
  }
}
