import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

enum LoadingState {
  idle,
  loading,
  refreshing,
  loadingMore,
  error,
}

class UserViewModel extends ChangeNotifier {  // Changed from UsersViewModel
  final UserService _userService = UserService();
  
  List<UserModel> _users = [];
  LoadingState _loadingState = LoadingState.idle;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;
  
  // Getters
  List<UserModel> get users => _users;
  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isEmpty => _users.isEmpty && _loadingState == LoadingState.idle;
  bool get isLoading => _loadingState == LoadingState.loading;
  bool get isRefreshing => _loadingState == LoadingState.refreshing;
  bool get isLoadingMore => _loadingState == LoadingState.loadingMore;
  
  // **CONSOLIDATED METHOD** - Handles all API call logic
  Future<void> _fetchUsers({
    required int page,
    required int perPage,
    required LoadingState loadingState,
    bool isLoadMore = false,
  }) async {
    if (_loadingState == loadingState) return;
    
    _loadingState = loadingState;
    _errorMessage = '';
    notifyListeners();
    
    try {
      final response = await _userService.getUsers(page: page, perPage: perPage);
      
      if (isLoadMore) {
        _users.addAll(response.data);
      } else {
        _users = response.data;
      }
      
      _currentPage = response.page;
      _totalPages = response.totalPages;
      _hasMore = _currentPage < _totalPages;
      _loadingState = LoadingState.idle;
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
    }
    
    notifyListeners();
  }
  
  // Load initial data - Uses consolidated method
  Future<void> loadUsers() async {
    await _fetchUsers(
      page: 1,
      perPage: 10,
      loadingState: LoadingState.loading,
    );
  }
  
  // Refresh data - Uses consolidated method
  Future<void> refreshUsers() async {
    await _fetchUsers(
      page: 1,
      perPage: 10,
      loadingState: LoadingState.refreshing,
    );
  }
  
  // Load more data - Uses consolidated method
  Future<void> loadMoreUsers() async {
    if (!_hasMore) return;
    
    await _fetchUsers(
      page: _currentPage + 1,
      perPage: 10,
      loadingState: LoadingState.loadingMore,
      isLoadMore: true,
    );
  }
  
  // Retry loading - Uses consolidated method
  Future<void> retry() async {
    await loadUsers();
  }
}