import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter/features/auth/screens/Login_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../../home/screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    print('Starting sign up process...');

    setState(() {
      _isLoading = true;
    });

    final result = await context.read<AuthService>().signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    print('Sign up result: $result');

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (result == 'success') {
      print('Navigation to HomeScreen...');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      print('Showing error: $result');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/svgs/twitter_logo.svg',
          color: Colors.blue,
          height: 30,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Text field 1
                TextField(
                  controller: _emailController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Email',

                  ),
                ),
                const SizedBox(height: 25),
                // Text field 2
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 40),
                // Button
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(120, 50),
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                  ),
                ),
                const SizedBox(height: 40),
                // Rich text
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign In",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
