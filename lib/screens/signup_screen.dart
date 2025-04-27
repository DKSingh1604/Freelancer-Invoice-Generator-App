import 'package:fig_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fig_app/repositories/auth_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _authRepository = AuthRepository();

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _authRepository.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Confirmation email sent. Kindly confirm and login.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sign up failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_signup.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).size.width * 0.06 > 24
                        ? 24.0
                        : MediaQuery.of(context).size.width * 0.06,
                vertical:
                    MediaQuery.of(context).size.height * 0.04 > 32
                        ? 32.0
                        : MediaQuery.of(context).size.height * 0.04,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(
                    builder: (context) {
                      final size = MediaQuery.of(context).size;
                      final logoSize =
                          size.width * 0.35 > 320 ? 320.0 : size.width * 0.35;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: logoSize,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Builder(
                    builder: (context) {
                      final size = MediaQuery.of(context).size;
                      final cardWidth =
                          size.width * 0.9 > 400 ? 400.0 : size.width * 0.9;
                      final cardPadding =
                          size.width * 0.08 > 32 ? 32.0 : size.width * 0.08;
                      final fieldSpacing =
                          size.height * 0.015 > 18 ? 18.0 : size.height * 0.015;
                      final buttonPadding =
                          size.height * 0.02 > 20 ? 20.0 : size.height * 0.02;
                      return Center(
                        child: SizedBox(
                          width: cardWidth,
                          child: Card(
                            elevation: 8,
                            color: const Color.fromARGB(
                              255,
                              164,
                              191,
                              205,
                            ).withOpacity(0.7),
                            shadowColor: Colors.blueGrey.withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(
                                color: Colors.blueGrey.shade100,
                                width: 2,
                              ),
                            ),

                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardPadding,
                                vertical: cardPadding,
                              ),
                              //FORM
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //EMAIL FORM
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!RegExp(
                                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                        ).hasMatch(value)) {
                                          return 'Enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),

                                    SizedBox(height: fieldSpacing),

                                    //PASSWORD FORM
                                    TextFormField(
                                      controller: _passwordController,
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: Icon(Icons.lock),
                                        border: OutlineInputBorder(),
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),

                                    SizedBox(height: fieldSpacing),

                                    //CONFIRM PASSWORD FORM
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      decoration: const InputDecoration(
                                        labelText: 'Confirm Password',
                                        prefixIcon: Icon(Icons.lock_outline),
                                        border: OutlineInputBorder(),
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),

                                    SizedBox(height: fieldSpacing * 1.5),

                                    //SIGN UP BUTTON
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: buttonPadding,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: _isLoading ? null : _signUp,
                                        child:
                                            _isLoading
                                                ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                                : const Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                      ),
                                    ),

                                    SizedBox(height: fieldSpacing * 0.7),

                                    //Already have an account? Login button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Already have an account?'),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const LoginScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text('Login'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
