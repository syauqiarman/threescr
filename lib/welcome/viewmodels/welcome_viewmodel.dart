import 'package:flutter/foundation.dart';
import '../models/welcome_model.dart';

class WelcomeViewModel extends ChangeNotifier {
  WelcomeModel _model = WelcomeModel.empty();

  String get userName => _model.userName;
  String get selectedUserName => _model.selectedUserName;

  void updateSelectedUserName(String selectedUserName) {
    if (selectedUserName.trim().isEmpty) {
      return; // Don't update with empty string
    }

    _model = _model.copyWith(selectedUserName: selectedUserName.trim());
    notifyListeners();
  }

  void initializeWithName(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return; // Don't update with empty string
    }

    // ✅ Check if username changed - if so, reset selectedUserName
    if (_model.userName != trimmedName) {
      _model = _model.copyWith(
        userName: trimmedName,
        selectedUserName: 'Selected User Name', // Reset selection for new user
      );
    } else {
      // Username sama, preserve selectedUserName
      _model = _model.copyWith(userName: trimmedName);
    }

    notifyListeners();
  }

  void resetSelectedUser() {
    _model = _model.copyWith(selectedUserName: 'Selected User Name');
    notifyListeners();
  }

  // ✅ Add method to completely reset state
  void resetState() {
    _model = WelcomeModel.empty();
    notifyListeners();
  }

  // ✅ Add method to check if user changed
  bool hasUserChanged(String newUserName) {
    return _model.userName != newUserName.trim();
  }
}