class UserState {
  static final UserState _instance = UserState._internal();
  factory UserState() => _instance;
  UserState._internal();

  List<String> selectedCategories = [];
  List<String> excludedIds = [];
}
