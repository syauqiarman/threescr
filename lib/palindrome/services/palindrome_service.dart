class PalindromeService {
  // Check if text is palindrome
  static bool isPalindrome(String text) {
    // Empty string is not considered a palindrome
    if (text.isEmpty) return false;
    
    // Remove spaces and convert to lowercase
    String cleanText = text.toLowerCase().replaceAll(' ', '');
    
    // Check if the string is the same when reversed
    return cleanText == cleanText.split('').reversed.join('');
  }

  static String getResultMessage(String sentence) {
    if (sentence.trim().isEmpty) {
      return "Please enter a sentence to check";
    }
    
    bool result = isPalindrome(sentence);
    return result ? "isPalindrome" : "not palindrome";
  }

  // Validate name input
  static String? validateName(String name) {
    return name.trim().isEmpty ? "Please enter your name" : null;
  }

  // Validate sentence input
  static String? validateSentence(String sentence) {
    return sentence.trim().isEmpty ? "Please enter a sentence to check" : null;
  }

  // Process palindrome check and return result message
  static String processPalindromeCheck(String sentence) {
    final trimmedSentence = sentence.trim();
    
    if (trimmedSentence.isEmpty) {
      return "Please enter a sentence to check";
    }

    return isPalindrome(trimmedSentence) ? "isPalindrome" : "not palindrome";
  }
}