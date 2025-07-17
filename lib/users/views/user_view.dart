import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_viewmodel.dart';
import '../models/user_model.dart';

class UserView extends StatefulWidget {
  final Function(String) onUserSelected;
  
  const UserView({super.key, required this.onUserSelected});
  
  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late ScrollController _scrollController;
  
  static const Color _greyLight = Color(0xFFE0E0E0);
  static const Color _greyMedium = Color(0xFFBDBDBD);
  static const Color _greyDark = Color(0xFF9E9E9E); 
  static const Color _greyDarker = Color(0xFF757575);
  static const Color _primaryColor = Color(0xFF554AF0);
  static const Color _shadowColor = Color(0x1A9E9E9E);
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadUsers();
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<UserViewModel>().loadMoreUsers();
    }
  }
  
  void _onUserTapped(UserModel user) {
    widget.onUserSelected(user.fullName);
    Navigator.pop(context);
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
            color: _primaryColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Third Screen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel);
        },
      ),
    );
  }
  
  Widget _buildBody(UserViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: _primaryColor,
        ),
      );
    }
    
    if (viewModel.loadingState == LoadingState.error && viewModel.users.isEmpty) {
      return _buildErrorState();
    }
    
    if (viewModel.isEmpty) {
      return _buildEmptyState();
    }
    
    return RefreshIndicator(
      onRefresh: () => context.read<UserViewModel>().refreshUsers(),
      color: _primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.users.length + (viewModel.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.users.length) {
            return _buildLoadingMoreIndicator();
          }
          
          final user = viewModel.users[index];
          return _buildUserItem(user);
        },
      ),
    );
  }
  
  Widget _buildUserItem(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _onUserTapped(user),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: _shadowColor,
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 49,
                height: 49,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    user.avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildAvatarPlaceholder();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildAvatarLoading();
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 10,
                        color: _greyDarker,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAvatarPlaceholder() {
    return Container(
      color: _greyLight,
      child: const Icon(
        Icons.person,
        color: _greyDarker,
        size: 24,
      ),
    );
  }
  
  Widget _buildAvatarLoading() {
    return Container(
      color: _greyLight,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: _primaryColor,
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _primaryColor,
        ),
      ),
    );
  }
  
  Widget _buildStateContent({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? actionButton,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: _greyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _greyDarker,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: _greyDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (actionButton != null) ...[
            const SizedBox(height: 24),
            actionButton,
          ],
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return _buildStateContent(
      icon: Icons.people_outline,
      title: 'No Users Found',
      subtitle: 'Pull down to refresh',
    );
  }
  
  Widget _buildErrorState() {
    return _buildStateContent(
      icon: Icons.error_outline,
      title: 'Something went wrong',
      subtitle: 'Unable to load users from API',
      actionButton: ElevatedButton(
        onPressed: () => context.read<UserViewModel>().retry(),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Retry'),
      ),
    );
  }
}