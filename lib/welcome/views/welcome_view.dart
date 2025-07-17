import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/welcome_viewmodel.dart';

class WelcomeView extends StatefulWidget {
  final String userName;
  
  const WelcomeView({
    super.key,
    required this.userName,
  });

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    // Initialize dengan proper state handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<WelcomeViewModel>();
      
      if (viewModel.hasUserChanged(widget.userName)) {
        viewModel.initializeWithName(widget.userName);
      } else {
        viewModel.initializeWithName(widget.userName);
      }
    });
  }

  void _onChooseUserPressed() {
    try {
      Navigator.pushNamed(
        context,
        '/users',
        arguments: (String selectedUserName) {
          context.read<WelcomeViewModel>().updateSelectedUserName(selectedUserName);
        },
      );
    } catch (e) {
      // Handle navigation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigation error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF554AF0),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Second Screen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<WelcomeViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel);
        },
      ),
    );
  }

  Widget _buildBody(WelcomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildWelcomeSection(viewModel),
          const Spacer(),
          _buildSelectedUserSection(viewModel),
          const Spacer(),
          _buildChooseUserButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(WelcomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          viewModel.userName,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedUserSection(WelcomeViewModel viewModel) {
    return Center(
      child: Text(
        viewModel.selectedUserName,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildChooseUserButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF2B637B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: _onChooseUserPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Choose a User',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}