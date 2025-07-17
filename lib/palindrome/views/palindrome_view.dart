import 'package:flutter/material.dart';
import '../viewmodels/palindrome_viewmodel.dart';

class PalindromeView extends StatefulWidget {
  const PalindromeView({super.key});

  @override
  State<PalindromeView> createState() => _PalindromeViewState();
}

class _PalindromeViewState extends State<PalindromeView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sentenceController = TextEditingController();
  late PalindromeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PalindromeViewModel();
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sentenceController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Result"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _onNextPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You have pressed the Next button"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onCheckPressed() {
    _viewModel.checkPalindrome();
    _showDialog(_viewModel.resultMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF66A8A7), // Teal
            Color(0xFF3A5988), // Light blue
          ],
        ),
      ),
      child: Stack(
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  _buildProfilePicture(),
                  const Spacer(flex: 1),
                  _buildTextField("Name", _nameController, _viewModel.updateName),
                  const SizedBox(height: 20),
                  _buildTextField("Palindrome", _sentenceController, _viewModel.updateSentence),
                  const SizedBox(height: 40),
                  _buildButton("CHECK", _onCheckPressed),
                  const SizedBox(height: 20),
                  _buildButton("NEXT", _onNextPressed),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Container(
        width: 116,
        height: 116,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0x40FFFFFF), // White dengan alpha 0x40 (25%)
        ),
        child: const Icon(
          Icons.person_add_alt_1,
          size: 44,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller, Function(String) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E3E4),
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF2B637B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000), // Black dengan alpha 0x26 (15%)
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}