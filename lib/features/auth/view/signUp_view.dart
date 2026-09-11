import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:e_commerce_mall/features/auth/data/auth_repo.dart';
import 'package:e_commerce_mall/features/auth/data/auth_validators.dart';
import 'package:e_commerce_mall/features/auth/view/login_view.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_card.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_footer_link.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_header.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_scaffold.dart';
import 'package:e_commerce_mall/features/auth/widgets/custom_button.dart';
import 'package:e_commerce_mall/shared/custom_textfomfield.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepo authRepo = AuthRepo();
  bool isLoading = false;

  (String firstName, String lastName) _splitName(String fullName) {
    final parts = fullName
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return ('', '');
    if (parts.length == 1) return (parts.first, '');
    return (parts.first, parts.sublist(1).join(' '));
  }

  String _usernameFrom(String email) {
    final local = email.split('@').first.toLowerCase();
    final cleaned = local.replaceAll(RegExp(r'[^a-z0-9._-]'), '');
    return cleaned.isEmpty ? 'user' : cleaned;
  }

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
    });
    try {
      final email = emailController.text.trim();
      final (firstName, lastName) = _splitName(nameController.text.trim());

      final user = await authRepo.signUp(
        firstName,
        lastName,
        _usernameFrom(email),
        email,
        passController.text.trim(),
      );
      if (user != null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AuthPalette.accent,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Account created. Please log in.',
              style: TextStyle(color: AuthPalette.onAccent),
            ),
          ),
        );

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        }
      }
    } catch (e) {
      final errorMsg = e is ApiError ? e.message : 'Unhandled error SignUp';

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AuthPalette.error,
          behavior: SnackBarBehavior.floating,
          content: Text(
            errorMsg,
            style: const TextStyle(color: AuthPalette.onAccent),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _openLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      children: [
        const AuthHeader(
          icon: Icons.person_add_alt_1,
          title: AppStrings.registerTitle,
          subtitle: AppStrings.registerSubtitle,
        ),
        const SizedBox(height: 32),
        AuthCard(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextfomfield(
                  label: 'Name',
                  hint: 'Enter your full name',
                  obsecure: false,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (v) => AuthValidators.required(v, 'Name'),
                ),
                const SizedBox(height: 18),
                CustomTextfomfield(
                  label: 'Email',
                  hint: 'Enter your email',
                  obsecure: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: AuthValidators.email,
                ),
                const SizedBox(height: 18),
                CustomTextfomfield(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  obsecure: false,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  validator: (v) => AuthValidators.required(v, 'Phone Number'),
                ),
                const SizedBox(height: 18),
                CustomTextfomfield(
                  label: 'Password',
                  hint: 'Enter your password',
                  obsecure: true,
                  controller: passController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: 18),
                CustomTextfomfield(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  obsecure: true,
                  controller: confirmPassController,
                  textInputAction: TextInputAction.done,
                  validator: (value) => AuthValidators.confirmPassword(
                    value,
                    passController.text,
                  ),
                ),
                const SizedBox(height: 26),
                CustomAuthButton(
                  isLoading: isLoading,
                  text: 'Register',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      signUp();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        AuthFooterLink(
          question: 'Already have an account?',
          action: 'Login',
          onTap: _openLogin,
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passController.dispose();
    confirmPassController.dispose();

    super.dispose();
  }
}