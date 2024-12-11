import 'package:flutter/material.dart';
import '../../../sessions/presentation/pages/sessions_history_page.dart';
import '../../../user_profile/presentation/pages/user_profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white), // Make the title text white
        ),
        centerTitle: true, // Center align the title
        backgroundColor: Colors.green, // Optional: Set the AppBar background color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set button background color
                foregroundColor: Colors.white, // Set button text color to white
              ),
              child: const Text('Go to User Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SessionsHistoryPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set button background color
                foregroundColor: Colors.white, // Set button text color to white
              ),
              child: const Text('Go to Sessions History'),
            ),
          ],
        ),
      ),
    );
  }
}
