import 'dart:io';

import 'package:ai_cricket_coach/features/user_profile/presentation/bloc/profile_cubit.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/bloc/profile_state.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/pages/edit_user_profile_page.dart';
import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:ai_cricket_coach/resources/app_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_entity.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getUserProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const CircularProgressIndicator();
          }
          if (state is ProfileLoaded) {
            UserEntity user = state.user;  // Get the user from the state

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    const Center(
                      child: CircleAvatar(
                        radius: 60, // Larger profile image
                        backgroundImage: AssetImage('lib/images/pfp.jpg'),
                      ),
                    ),
                    const SizedBox(height: 20), // Spacing between image and name

                    // User Information
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Name
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8), // Spacing between name and other details

                          // Age, City, Country, Team
                          Text(
                            '${user.age ?? 'Not available'}, ${user.city ?? 'Not available'}, ${user.country ?? 'Not available'}, Team: ${user.teamName ?? 'Not available'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 80), // Spacing before buttons

                          // Buttons
                          Column(
                            children: [
                              // Edit Profile Button
                              ElevatedButton.icon(
                                onPressed: () async{
                                  AppNavigator.push(context, EditUserProfilePage(user: user));},
                                icon: const Icon(Icons.edit, color: Colors.white),
                                label: const Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary, // Button background color
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 111),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16), // Spacing between buttons

                              // Settings Button
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.settings, color: Colors.white),
                                label: const Text(
                                  'Settings',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary, // Button background color
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 120),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16), // Spacing between buttons

                              // Log Out Button
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.logout, color: Colors.white),
                                label: const Text(
                                  'Log Out',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary, // Button background color
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 120),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16), // Spacing between buttons

                              // Terms and Agreement Button
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.library_books, color: Colors.white),
                                label: const Text(
                                  'Terms and Agreement',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary, // Button background color
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]




              ),
            );
          }
          // if(state is ProfileLoadedWithPicture){
          //   UserEntity user = state.user;  // Get the user from the state
          //   String profilePicturePath = state.profilePicturePath;
          //
          //   return Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const CircleAvatar(
          //           radius: 50,
          //           backgroundImage: AssetImage('lib/images/pfp.png'), //FileImage(File(profilePicturePath)), // Use the local image if URL is null
          //         ),
          //         const SizedBox(height: 16),
          //
          //
          //         // Display user's first and last name
          //         Text(
          //           '${user.firstName} ${user.lastName}',
          //           style: Theme.of(context).textTheme.titleLarge,
          //         ),
          //         const SizedBox(height: 8),
          //
          //         // Display user's role and team
          //         Text(
          //           'Role: ${user.role ?? 'Not available'}',
          //           style: Theme.of(context).textTheme.titleMedium,
          //         ),
          //         Text(
          //           'Team: ${user.teamName ?? 'Not available'}',
          //           style: Theme.of(context).textTheme.titleMedium,
          //         ),
          //         const SizedBox(height: 16),
          //
          //         // Display user's other details
          //         Text(
          //           'Email: ${user.email ?? 'Not available'}',
          //           style: Theme.of(context).textTheme.bodyLarge,
          //         ),
          //         Text(
          //           'Age: ${user.age ?? 'Not available'}',
          //           style: Theme.of(context).textTheme.bodyLarge,
          //         ),
          //         Text(
          //           'City: ${user.city ?? 'Not available'}',
          //           style: Theme.of(context).textTheme.bodyLarge,
          //         ),
          //         Text(
          //           'Country: ${user.country ?? 'Not available'}',
          //           style: Theme.of(context).textTheme.bodyLarge,
          //         ),
          //         const SizedBox(height: 16),
          //
          //         // Display description
          //         Text(
          //           'Description: ${user.description ?? 'Not available'}',
          //           style: Theme.of(context).textTheme.bodyMedium,
          //         ),
          //       ],
          //     ),
          //   );
          //
          //
          // }
          if (state is ProfileLoadingFailed){
            return Text(state.errorMessage);
          }
          return Container();
        }
      )
    );
  }

}