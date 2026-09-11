import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/features/auth/view/profile_view.dart';
import 'package:e_commerce_mall/shared/brand_wordmark.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Home screen header: the mark, a greeting, and the account avatar.
class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandWordmark(size: 20),
              const SizedBox(height: 14),
              Text(
                AppStrings.homeGreeting,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.homeSubtitle,
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileView(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(26),
          child: CircleAvatar(
            radius: 26,
            backgroundColor: colors.surfaceMuted,
            child: Icon(CupertinoIcons.person, color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}