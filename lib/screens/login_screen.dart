import 'package:fig_app/repositories/auth_repository.dart';
import 'package:fig_app/screens/dashboard_screen.dart';
import 'package:fig_app/screens/get_details_screen.dart';
import 'package:fig_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _authRepository.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GetDetailsScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed')));
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _signUp() async {
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
          MaterialPageRoute(
            builder:
                (context) =>
                    DashboardScreen(nickname: '', fullname: '', company: ''),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign up failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: [38;5;9m${e.toString()}[0m')),
      );
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
              padding: const EdgeInsets.all(24.0),
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
                              189,
                              211,
                              222,
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: fieldSpacing),
                                  TextField(
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(height: fieldSpacing * 1.5),
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
                                      onPressed: _isLoading ? null : _login,
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
                                                'Login',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                    ),
                                  ),
                                  SizedBox(height: fieldSpacing * 0.7),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('No account?'),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const SignupScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
