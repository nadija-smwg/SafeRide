import 'package:flutter/material.dart';

// Custom Text Field used in Login, Register, etc.
class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller; // Capture user input later!

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Variable to track whether text is hidden or visible
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Start out hidden if it's a password field
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller:
            widget.controller, // Connects the text field to the controller
        obscureText: _obscureText, // Uses the variable to show/hide text!
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFF7F8F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          // Upgraded from Icon to IconButton!
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    // Changes the icon image depending on the state
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // This is the magic that flips the state and redraws the screen
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

// Social Login Button Row (FIXED FOR OVERFLOW)
class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Wrapping them in 'Expanded' forces them to fit perfectly on any screen size
        Expanded(child: _buildSocialBtn(Icons.facebook, Colors.blue)),
        const SizedBox(width: 16), // Adds spacing between buttons
        Expanded(
          child: _buildSocialBtn(
            Icons.g_mobiledata,
            Colors.red,
            isGoogle: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildSocialBtn(Icons.apple, Colors.black)),
      ],
    );
  }

  Widget _buildSocialBtn(IconData icon, Color color, {bool isGoogle = false}) {
    return Container(
      // NOTICE: width: 100 is completely gone from here!
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(icon, color: color, size: isGoogle ? 40 : 30),
      ),
    );
  }
}
