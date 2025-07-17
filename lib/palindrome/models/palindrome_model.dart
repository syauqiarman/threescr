class PalindromeModel {
  final String name;
  final String sentence;
  final bool isPalindrome;

  const PalindromeModel({
    required this.name,
    required this.sentence,
    required this.isPalindrome,
  });

  factory PalindromeModel.empty() {
    return const PalindromeModel(
      name: '',
      sentence: '',
      isPalindrome: false,
    );
  }

  PalindromeModel copyWith({
    String? name,
    String? sentence,
    bool? isPalindrome,
  }) {
    return PalindromeModel(
      name: name ?? this.name,
      sentence: sentence ?? this.sentence,
      isPalindrome: isPalindrome ?? this.isPalindrome,
    );
  }
}