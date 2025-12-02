import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/presentation/auth/widgets/reusable_form.dart';
import 'package:kosan_kan/presentation/auth/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }
    context.read<AuthBloc>().add(LoginRequested(username, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // optional: show loading indicator
          } else if (state is AuthAuthenticated) {
            // navigate to main navigation page
            context.go('/app');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                // Top half image
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/images/image_3.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),

                // Bottom half: scrollable form area to avoid overflow
                Expanded(
                  flex: 1,
                  child: Container(
                    color: const Color(0xFFF8F8F8),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        24.0,
                        16.0,
                        24.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ReusableForm(
                                  title: 'Login',
                                  fields: [
                                    TextField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  onSubmit: _onSubmit,
                                  submitButtonText: 'Login',
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context.push('/auth/register');
                                      },
                                      child: const Text('Register'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.push('/auth/forget-password');
                                      },
                                      child: const Text('Forgot Password?'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Back button (top-left) - only show if navigator can pop.
            Navigator.of(context).canPop()
                ? Positioned(
                    top: 8,
                    left: 8,
                    child: SafeArea(
                      child: ClipOval(
                        child: Material(
                          color: Colors.white.withOpacity(0.8),
                          child: InkWell(
                            onTap: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                // Fallback to main app navigation
                                context.go('/app');
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_back, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
