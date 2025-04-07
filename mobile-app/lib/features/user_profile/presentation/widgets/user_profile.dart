import 'dart:io';
import 'package:ai_cricket_coach/features/user_profile/presentation/bloc/profile_cubit.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/bloc/profile_state.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/pages/edit_user_profile_page.dart';
import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:ai_cricket_coach/resources/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..getUserProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            return _buildProfile(context, state.user, 'lib/images/default-pfp.jpg');
          }

          if (state is ProfileLoadedWithPicture) {
            return _buildProfile(context, state.user, state.profilePicturePath);
          }

          if (state is ProfileLoadingFailed) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfile(BuildContext context, UserEntity user, String pfpPath) {
    final isLocalFile = pfpPath.startsWith('/') || pfpPath.contains('storage/emulated');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileHeader(context, user, pfpPath, isLocalFile),
          const SizedBox(height: 16),
          Text(
            user.description ?? '',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader(BuildContext context, UserEntity user, String pfpPath, bool isLocalFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {
              AppNavigator.push(
                context,
                EditUserProfilePage(user: user, pfpPath: pfpPath),
              );
            },
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: isLocalFile
                  ? FileImage(File(pfpPath))
                  : AssetImage(pfpPath) as ImageProvider,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${user.age ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.teamName?.isNotEmpty == true ? 'Team: ${user.teamName}' : '',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          _formatLocation(user.city, user.country),
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatLocation(String? city, String? country) {
    if ((city?.isNotEmpty ?? false) && (country?.isNotEmpty ?? false)) {
      return '$city, $country';
    }
    return city?.isNotEmpty == true
        ? city!
        : country?.isNotEmpty == true
        ? country!
        : '';
  }
}
