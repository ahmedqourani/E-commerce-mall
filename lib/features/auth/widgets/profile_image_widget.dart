import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? profileImage;

  const ProfileImageWidget({super.key, this.profileImage});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: profileImage == null
          ? Image.asset(
              'assets/logo/Mask_group.jpg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            )
          : Image.network(
              profileImage!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/logo/Mask_group.jpg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }
}
