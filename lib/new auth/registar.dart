import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes/App_routesName.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Booknest Theme Colors
  static const Color primaryColor = Color(0xFF6D4C41); // Brown 600
  static const Color accentColor = Color(0xFFFFD54F); // Amber 300
  static const Color textColor = Color(0xFF5D4037); // Brown 800
  static const Color lightTextColor = Color(0xFF8D6E63); // Brown 400

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();

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
                Center(
                  child: Image.asset(
                    'assets/images/book logo.png', // Replace with your logo
                    height: size.height * 0.15,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  'Create Account',
                  style: GoogleFonts.merriweather(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Start your book sharing journey today',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: lightTextColor,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                _buildNameField(size),
                SizedBox(height: size.height * 0.02),
                _buildEmailField(size),
                SizedBox(height: size.height * 0.02),
                _buildPhoneField(size),
                SizedBox(height: size.height * 0.02),
                _buildPasswordField(size),
                SizedBox(height: size.height * 0.02),
                _buildConfirmPasswordField(size),
                SizedBox(height: size.height * 0.04),
                _buildRegisterButton(size),
                SizedBox(height: size.height * 0.03),
                _buildLoginPrompt(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(Size size) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: "Full Name",
        labelStyle: GoogleFonts.roboto(color: lightTextColor),
        prefixIcon: Icon(Icons.person, color: primaryColor),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (text) => text?.isEmpty ?? true ? 'Please enter your name' : null,
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

  Widget _buildPhoneField(Size size) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Phone Number",
        labelStyle: GoogleFonts.roboto(color: lightTextColor),
        prefixIcon: Icon(Icons.phone, color: primaryColor),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (text) =>
      text?.isEmpty ?? true ? 'Please enter phone number' : null,
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

  Widget _buildConfirmPasswordField(Size size) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        labelStyle: GoogleFonts.roboto(color: lightTextColor),
        prefixIcon: Icon(Icons.lock, color: primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: lightTextColor,
          ),
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (text) {
        if (text != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  Widget _buildRegisterButton(Size size) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
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
          'REGISTER',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.roboto(
            color: lightTextColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutesname.Login2,
            );
          },
          child: Text(
            "Sign In",
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

  Future<void> _register() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);

    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),

      });

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutesname.MainScreen,
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    } catch (e) {

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}