import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:e_commerce_mall/features/auth/data/auth_repo.dart';
import 'package:e_commerce_mall/features/auth/data/auth_validators.dart';
import 'package:e_commerce_mall/features/auth/view/signUp_view.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_card.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_footer_link.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_header.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_scaffold.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_text_styles.dart';
import 'package:e_commerce_mall/features/auth/widgets/custom_button.dart';
import 'package:e_commerce_mall/root.dart';
import 'package:e_commerce_mall/shared/custom_textfomfield.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthRepo authRepo = AuthRepo();
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await authRepo.login(
        usernameController.text.trim(),
        passController.text.trim(),
      );

      if (user != null) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Root()),
        );
      }
    } catch (e) {
      final errorMsg = e is ApiError ? e.message : 'Unhandled error login';

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AuthPalette.error,
          behavior: SnackBarBehavior.floating,
          content: Text(errorMsg, style: AuthTextStyles.snackBar(context)),
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

  void _openRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupView()),
    );
  }

  void _openForgotPassword() {
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      children: [
        const AuthHeader(
          icon: Icons.storefront_outlined,
          title: AppStrings.loginTitle,
          subtitle: AppStrings.loginSubtitle,
        ),
        const SizedBox(height: 32),
        AuthCard(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextfomfield(
                  label: 'Email or Username',
                  hint: 'Enter your email or username',
                  obsecure: false,
                  controller: usernameController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  validator: AuthValidators.identifier,
                ),
                const SizedBox(height: 18),
                CustomTextfomfield(
                  label: 'Password',
                  hint: 'Enter your password',
                  obsecure: true,
                  controller: passController,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _openForgotPassword,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AuthPalette.accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                CustomAuthButton(
                  text: 'Login',
                  isLoading: isLoading,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        AuthFooterLink(
          question: "Don't have an account?",
          action: 'Register',
          onTap: _openRegister,
        ),
      ],
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passController.dispose();
    super.dispose();
  }
}