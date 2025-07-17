import 'package:flutter/foundation.dart';
import '../models/welcome_model.dart';

class WelcomeViewModel extends ChangeNotifier {
  WelcomeModel _model = WelcomeModel.empty();

  // Getters
  String get userName => _model.userName;
  String get selectedUserName => _model.selectedUserName;

  // Update methods
  void updateUserName(String userName) {
    _model = _model.copyWith(userName: userName);
    notifyListeners();
  }

  void updateSelectedUserName(String selectedUserName) {
    _model = _model.copyWith(selectedUserName: selectedUserName);
    notifyListeners();
  }

  // Initialize with name from first screen
  void initializeWithName(String name) {
    _model = _model.copyWith(userName: name);
    notifyListeners();
  }

  // Reset selected user
  void resetSelectedUser() {
    _model = _model.copyWith(selectedUserName: 'Selected User Name');
    notifyListeners();
  }
}