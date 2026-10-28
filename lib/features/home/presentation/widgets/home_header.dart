import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final String name = state is ProfileLoaded
              ? state.profileName
              : '';
          final String? imagePath = state is ProfileLoaded
              ? state.profileImagePath
              : null;
          final String? gender = state is ProfileLoaded
              ? state.gender
              : null;

          final greetingText = name.isNotEmpty
              ? "السلام عليكم، $name"
              : "السلام عليكم";

          ImageProvider avatarImage;
          if (imagePath != null && File(imagePath).existsSync()) {
            avatarImage = FileImage(File(imagePath));
          } else if (gender == 'female') {
            avatarImage = const AssetImage(
              'assets/images/Ellipse 12 (1).png',
            );
          } else if (gender == 'male') {
            avatarImage = const AssetImage(
              'assets/images/Ellipse 12.png',
            );
          } else {
            avatarImage = const AssetImage(
              'assets/images/avatar_1.jpg',
            );
          }

        
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final avatarRadius = (width * 0.067).clamp(20.0, 25.0);
              final gap = (width * 0.032).clamp(8.0, 12.0);
              final likeSize = (width * 0.043).clamp(13.0, 16.0);

              return Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: avatarImage,
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            greetingText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  height: 1.2,
                                ),
                          ),
                          SizedBox(height: width * 0.008),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "جميل أنك عدت اليوم",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              SizedBox(width: 3),
                              Image.asset(
                                "assets/icons/like.png",
                                width: likeSize,
                                height: likeSize,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
  }
}