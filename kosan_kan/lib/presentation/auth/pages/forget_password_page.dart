import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/presentation/auth/widgets/reusable_form.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final imageHeight = media.height * 0.5;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8), // same background as login
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/forget_password_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: media.height - imageHeight,
                  color: const Color(0xFFF8F8F8),
                  width: double.infinity,
                ),
              ],
            ),

            // bottom-aligned scrollable form
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 300.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: media.height - 80),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReusableForm(
                            title: 'Forget Password',
                            fields: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                            onSubmit: () {
                              // Handle forget password logic here
                            },
                            submitButtonText: 'Submit',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Back button (top-left)
            Positioned(
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
                          context.push('/auth/login');
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
            ),
          ],
        ),
      ),
    );
  }
}
