class WelcomeModel {
  final String userName;
  final String selectedUserName;

  const WelcomeModel({
    required this.userName,
    required this.selectedUserName,
  });

  factory WelcomeModel.empty() {
    return const WelcomeModel(
      userName: '',
      selectedUserName: 'Selected User Name',
    );
  }

  WelcomeModel copyWith({
    String? userName,
    String? selectedUserName,
  }) {
    return WelcomeModel(
      userName: userName ?? this.userName,
      selectedUserName: selectedUserName ?? this.selectedUserName,
    );
  }
}