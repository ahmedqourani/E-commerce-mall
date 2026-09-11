import 'package:e_commerce_mall/core/constants/app_colors.dart';
import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/utils/pref_helper.dart';
import 'package:e_commerce_mall/features/auth/data/auth_repo.dart';
import 'package:e_commerce_mall/features/auth/view/login_view.dart';
import 'package:e_commerce_mall/features/auth/widgets/logout_dialog.dart';
import 'package:e_commerce_mall/features/auth/widgets/payment_mehod_tile.dart';
import 'package:e_commerce_mall/features/auth/widgets/profile_action_buttons.dart';
import 'package:e_commerce_mall/features/auth/widgets/profile_form_fields.dart';
import 'package:e_commerce_mall/features/auth/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();

  final AuthRepo authRepo = AuthRepo();
  bool isLoading = false;
  String? profileImage;
  String selectedMethod = 'Visa';
  int? userId;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    super.dispose();
  }

  Future<void> getProfile() async {
    setState(() => isLoading = true);
    try {
      final user = await authRepo.getProfile();
      if (user != null) {
        userId = user.id;
        firstNameController.text = user.firstName;
        lastNameController.text = user.lastName;
        usernameController.text = user.username;
        emailController.text = user.email;
        phoneController.text = user.phone ?? 'Not available';
        genderController.text = user.gender ?? 'Not available';
        profileImage = user.image;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          content: Text(
            e is ApiError ? e.message : 'Failed to load profile',
            style: TextStyle(color: context.colors.onError),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile() async {
    try {
      final user = await authRepo.updateProfile(
        id: userId!,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
      );
      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: context.colors.success,
            content: Text(
              'Profile updated successfully',
              style: TextStyle(color: context.colors.onSuccess),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          content: Text(
            e is ApiError ? e.message : 'Failed to update profile',
            style: TextStyle(color: context.colors.onError),
          ),
        ),
      );
    }
  }

  Future<void> logout() async {
    await PrefHelper.clearSession();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  void _handleLogout() async {
    final shouldLogout = await showLogoutDialog(context);
    if (shouldLogout == true) {
      await logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.brandBackground,
      appBar: AppBar(
        backgroundColor: colors.brandBackground,
        foregroundColor: colors.onBrand,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onBrand),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: colors.onBrand),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colors.onBrand))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  ProfileImageWidget(profileImage: profileImage),
                  const SizedBox(height: 20),
                  ProfileFormFields(
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    usernameController: usernameController,
                    emailController: emailController,
                    phoneController: phoneController,
                    genderController: genderController,
                  ),
                  const SizedBox(height: 20),
                  Divider(color: colors.brandDivider),
                  const SizedBox(height: 20),
                  PaymentMethodTile(
                    selectedMethod: selectedMethod,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedMethod = value);
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  ProfileActionButtons(
                    onEditProfile: () {
                      if (userId != null) updateProfile();
                    },
                    onLogout: _handleLogout,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
