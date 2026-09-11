import 'package:flutter/material.dart';
import 'package:e_commerce_mall/features/auth/widgets/custom_textfield.dart';

class ProfileFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController genderController;

  const ProfileFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.emailController,
    required this.phoneController,
    required this.genderController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextfield(
          labelText: 'First Name',
          controller: firstNameController,
        ),
        const SizedBox(height: 20),
        CustomTextfield(labelText: 'Last Name', controller: lastNameController),
        const SizedBox(height: 20),
        CustomTextfield(labelText: 'Username', controller: usernameController),
        const SizedBox(height: 20),
        CustomTextfield(labelText: 'Email', controller: emailController),
        const SizedBox(height: 20),
        CustomTextfield(labelText: 'Phone', controller: phoneController),
        const SizedBox(height: 20),
        CustomTextfield(labelText: 'Gender', controller: genderController),
      ],
    );
  }
}
