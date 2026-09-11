import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_mall/shared/custom_text.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  const ProfileActionButtons({
    super.key,
    required this.onEditProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onEditProfile,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                // The primary action, so it carries the accent. Was a white
                // fill, which flares against a near-black screen.
                color: colors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Edit Profile',
                    size: 18,
                    color: colors.onPrimary,
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.edit, color: colors.onPrimary),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onLogout,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: colors.brandBackground,
                // Was a 2px off-white outline — too loud beside the accent fill
                // next to it. A grey hairline reads as the quieter of the pair.
                border: Border.all(color: colors.borderStrong),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Log Out',
                    size: 18,
                    color: colors.onBrand,
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.logout, color: colors.onBrand),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
