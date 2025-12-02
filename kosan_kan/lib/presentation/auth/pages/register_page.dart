import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/presentation/auth/widgets/reusable_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/images/register_image.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

            Expanded(
              flex: 3,
              child: Container(
                color: const Color(0xFFF8F8F8),
                width: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: media.height * 0.4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ReusableForm(
                                title: 'Register',
                                fields: [
                                  const SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                                onSubmit: () {
                                  // Handle registration logic here
                                  context.push('/auth/login');
                                },
                                submitButtonText: 'Register',
                              ),

                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account? "),
                                  TextButton(
                                    onPressed: () {
                                      context.push('/auth/login');
                                    },
                                    child: const Text('Login'),
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
            ),
          ],
        ),
      ),
    );
  }
}
