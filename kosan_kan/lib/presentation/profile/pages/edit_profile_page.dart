import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/presentation/profile/bloc/profile_bloc.dart';
import 'package:kosan_kan/domain/usecases/user_usecase.dart';
import 'package:kosan_kan/app/di/getIt.dart' as di;
import 'package:kosan_kan/presentation/auth/bloc/auth_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstController;
  late TextEditingController _lastController;
  late TextEditingController _phoneController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state is AuthAuthenticated
        ? (context.read<AuthBloc>().state as AuthAuthenticated).user
        : null;
    _firstController = TextEditingController(text: user?.firstName ?? '');
    _lastController = TextEditingController(text: user?.lastName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    ctx.read<ProfileBloc>().add(
      UpdateProfile(
        _firstController.text.trim(),
        _lastController.text.trim(),
        _phoneController.text.trim(),
      ),
    );
  }

  String? _validateName(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    return null;
  }

  String? _validatePhone(String? v) {
    final cleaned = v?.trim() ?? '';
    if (cleaned.isEmpty) return 'Nomor telepon harus diisi';
    // Use a strict digits-only regex
    final digitsOnlyFixed = RegExp(r'^\d+$');
    if (!digitsOnlyFixed.hasMatch(cleaned)) return 'Masukkan hanya angka';
    if (cleaned.length < 12) return 'Nomor minimal 12 digit';
    if (cleaned.length > 13) return 'Nomor maksimal 13 digit';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(di.sl<UserUsecase>()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            setState(() => _isSubmitting = true);
          } else {
            setState(() => _isSubmitting = false);
          }

          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Profile updated')));
            // Update global AuthBloc user so other screens reflect the change
            try {
              final user = state.profile;
              context.read<AuthBloc>().add(UpdateAuthenticatedUser(user));
            } catch (_) {}
            try {
              context.pop();
            } catch (_) {
              // If there's nothing to pop (deep link or replaced route),
              // navigate to profile tab as a safe fallback.
              try {
                context.go('/app?tab=profile');
              } catch (_) {}
            }
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Edit Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // If there is a navigation back stack, pop normally.
                // Otherwise navigate to the app shell with the Profile tab so
                // the bottom navigation is present.
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go('/app?tab=profile');
                }
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstController,
                    decoration: const InputDecoration(labelText: 'First name'),
                    validator: _validateName,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastController,
                    decoration: const InputDecoration(labelText: 'Last name'),
                    validator: _validateName,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (innerCtx) {
                      return ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _submit(innerCtx),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
