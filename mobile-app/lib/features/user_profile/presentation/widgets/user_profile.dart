import 'dart:io';

import 'package:ai_cricket_coach/features/authentication/presentation/pages/loading_page.dart';
import 'package:ai_cricket_coach/features/authentication/presentation/pages/log_in_page.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/bloc/profile_cubit.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/bloc/profile_state.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/pages/edit_user_profile_page.dart';
import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:ai_cricket_coach/resources/app_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/service_locator.dart';
import '../../../authentication/domain/usecases/logout_usecase.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../domain/entities/user_entity.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProfileCubit()..getUserProfile(),
        child:
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          if (state is ProfileLoading) {
            return const CircularProgressIndicator();
          }
          if (state is ProfileLoaded)  {
            debugPrint('HelloHello');
            UserEntity user = state.user; // Get the user from the state

            Widget _homeBar(BuildContext context) {
              return AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.home_sharp, color: AppColors.primary,),
                  onPressed: () {
                    // Replace with your actual home navigation logic
                    AppNavigator.pushAndRemove(context, HomePage());
                  },
                ),
                actions: [
                  // Add an icon to the top right
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary,),  // Replace with any icon
                    onPressed: () async {
                      AppNavigator.push(
                          context,
                          EditUserProfilePage(
                            user: user,
                            pfpPath: 'lib/images/default-pfp.jpg',
                          ));
                      context.read<ProfileCubit>().getUserProfile();// Fetch fresh data

                    },

                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10.0), // Main page padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _homeBar(context),

                  const SizedBox(height: 16), // Optional spacing after AppBar


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0), // Or whatever padding you prefer
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row for Profile Picture and User Info
                        Row(
                          children: [
                            // Profile Picture
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                              const AssetImage('lib/images/default-pfp.jpg'),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${user.email ?? 'Not available'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${user.age ?? 'Not available'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Team ${user.teamName ?? 'Not available'}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${user.city ?? 'Not available'}, ${user.country ?? 'Not available'}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          '${user.description ?? 'Not available'}',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // Buttons section comes here if you have it
                ],
              ),
            );


          }
          if (state is ProfileLoadedWithPicture) {
            debugPrint('HelloHello');
            UserEntity user = state.user; // Get the user from the state
            String profilePicturePath = state.profilePicturePath;

            Widget _homeBar(BuildContext context) {
              return AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.home_sharp, color: AppColors.primary,),
                  onPressed: () {
                    // Replace with your actual home navigation logic
                    AppNavigator.pushAndRemove(context, HomePage());
                  },
                ),
                actions: [
                  // Add an icon to the top right
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary,),  // Replace with any icon
                    onPressed: () async {
                      AppNavigator.push(
                          context,
                          EditUserProfilePage(
                            user: user,
                            pfpPath: profilePicturePath,
                          ));
                      context.read<ProfileCubit>().getUserProfile();// Fetch fresh data

                    },

                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10.0), // Main page padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _homeBar(context),

                  const SizedBox(height: 16), // Optional spacing after AppBar


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0), // Or whatever padding you prefer
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row for Profile Picture and User Info
                        Row(
                          children: [
                            // Profile Picture
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: FileImage(File(profilePicturePath)),
                              onBackgroundImageError: (_, __) =>
                              const AssetImage('lib/images/default-pfp.jpg'),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${user.email ?? 'Not available'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${user.age ?? 'Not available'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Team ${user.teamName ?? 'Not available'}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${user.city ?? 'Not available'}, ${user.country ?? 'Not available'}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          '${user.description ?? 'Not available'}',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // Buttons section comes here if you have it
                ],
              ),
            );


          }
          if (state is ProfileLoadingFailed) {
            return Text(state.errorMessage);
          }
          return Container();
        }));
  }
}
