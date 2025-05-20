import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes/App_routesName.dart';
import 'auth_helper.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  // Booknest Theme Colors
  static const Color primaryColor = Color(0xFF6D4C41); // Brown 600
  static const Color accentColor = Color(0xFFFFD54F); // Amber 300
  static const Color textColor = Color(0xFF5D4037); // Brown 800
  static const Color lightTextColor = Color(0xFF8D6E63); // Brown 400

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill for testing (remove in production)

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: isPortrait ? size.height * 0.05 : size.height * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 85,),
                Center(
                  child: Image.asset(
                    'assets/images/book logo.png', // Replace with your logo
                    height: size.height * 0.15,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.merriweather(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Sign in to continue your book journey',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: lightTextColor,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                _buildEmailField(size),
                SizedBox(height: size.height * 0.02),
                _buildPasswordField(size),
                SizedBox(height: size.height * 0.02),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutesname.forgotPassword),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.roboto(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                _buildLoginButton(size),
                SizedBox(height: size.height * 0.04),

                SizedBox(height: size.height * 0.02),
                _buildSignUpPrompt(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(Size size) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: GoogleFonts.roboto(color: lightTextColor),
        prefixIcon: Icon(Icons.email, color: primaryColor),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) return 'Please enter email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(Size size) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: GoogleFonts.roboto(color: lightTextColor),
        prefixIcon: Icon(Icons.lock, color: primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: lightTextColor,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) return 'Please enter password';
        if (text.length < 6) return "Password must be at least 6 characters";
        return null;
      },
    );
  }

  Widget _buildLoginButton(Size size) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          'LOG IN',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _buildSignUpPrompt(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.roboto(
            color: lightTextColor,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutesname.Registar,
          ),
          child: Text(
            "Sign Up",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);

    try {
      final userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutesname.MainScreen,
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        default:
          errorMessage = 'Login failed. Please try again';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}