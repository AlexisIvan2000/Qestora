import 'package:flutter/material.dart';
import 'package:front_end/models/register_request.dart';
import 'package:front_end/services/auth_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  void _register() async{
    final request = RegisterRequest(
      fullName: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    final result = await AuthService.register(request);
    if (result != null && !result.startsWith("Error")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Registration failed')),
      );
    }
   
    
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create Account ",
            style: theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Fill in your details to get started",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),

          const SizedBox(height: 28),

          _label("Full Name"),
          _inputField(
            controller: _nameController,
            hint: "Enter your full name",
            validator: (v) => v == null || v.isEmpty ? "Name required" : null,
          ),

          const SizedBox(height: 20),

          _label("Email"),
          _inputField(
            controller: _emailController,
            hint: "Enter your email",
            keyboard: TextInputType.emailAddress,
            validator: (v) => v == null || v.isEmpty ? "Email required" : null,
          ),

          const SizedBox(height: 20),

          _label("Password"),
          _inputField(
            controller: _passwordController,
            hint: "Enter your password",
            obscure: !_passwordVisible,
            icon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _passwordVisible = !_passwordVisible),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return "Password required";
              if (v.length < 6) return "Minimum 6 characters";
              return null;
            },
          ),

          const SizedBox(height: 20),

          _label("Confirm Password"),
          _inputField(
            controller: _confirmController,
            hint: "Re-enter your password",
            obscure: !_confirmPasswordVisible,
            icon: IconButton(
              icon: Icon(
                _confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => setState(
                () => _confirmPasswordVisible = !_confirmPasswordVisible,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return "Please confirm password";
              if (v != _passwordController.text){
                return "Passwords do not match";
              }
                
              return null;
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _register();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "Create Account",
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/google.png", height: 24),
                  const SizedBox(width: 10),
                  Text(
                    "Continue with Google",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(color: Colors.grey.shade700),
                  children: [
                    TextSpan(
                      text: "Login",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboard,
    bool obscure = false,
    Widget? icon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: icon,
      ),
      validator: validator,
    );
  }
}
