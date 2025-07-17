import 'package:flutter/foundation.dart';
import '../models/palindrome_model.dart';
import '../services/palindrome_service.dart';

class PalindromeViewModel extends ChangeNotifier {
  PalindromeModel _model = PalindromeModel.empty();
  String _resultMessage = '';

  // Simple getters
  String get name => _model.name;
  String get sentence => _model.sentence;
  String get resultMessage => _resultMessage;

  // Update methods - same as original onChanged
  void updateName(String name) {
    _model = _model.copyWith(name: name);
    notifyListeners();
  }

  void updateSentence(String sentence) {
    _model = _model.copyWith(sentence: sentence);
    notifyListeners();
  }

  // Check palindrome - same logic as original _checkPalindrome
  void checkPalindrome() {
    _resultMessage = PalindromeService.getResultMessage(_model.sentence);
    
    if (_resultMessage == "isPalindrome" || _resultMessage == "not palindrome") {
      bool isPalindromeResult = PalindromeService.isPalindrome(_model.sentence);
      _model = _model.copyWith(isPalindrome: isPalindromeResult);
    }
    
    notifyListeners();
  }
}