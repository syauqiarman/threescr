import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/palindrome_viewmodel.dart';

class PalindromeView extends StatefulWidget {
  const PalindromeView({super.key});

  @override
  State<PalindromeView> createState() => _PalindromeViewState();
}

class _PalindromeViewState extends State<PalindromeView> {
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
    final viewModel = context.read<PalindromeViewModel>();
    if (viewModel.name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your name first"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/welcome',
      arguments: viewModel.name.trim(),
    );
  }

  void _onCheckPressed() {
    final viewModel = context.read<PalindromeViewModel>();
    viewModel.checkPalindrome();
    _showDialog(viewModel.resultMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PalindromeViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel);
        },
      ),
    );
  }

  Widget _buildBody(PalindromeViewModel viewModel) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF66A8A7),
            Color(0xFF3A5988),
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
                  _buildTextField(
                    "Name",
                    viewModel.name,
                    (value) => viewModel.updateName(value),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    "Palindrome",
                    viewModel.sentence,
                    (value) => viewModel.updateSentence(value),
                  ),
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
          color: Color(0x40FFFFFF),
        ),
        child: const Icon(
          Icons.person_add_alt_1,
          size: 44,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText,
    String value,
    Function(String) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E3E4),
          width: 0.5,
        ),
      ),
      child: TextFormField(
        initialValue: value,
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
            color: Color(0x26000000),
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