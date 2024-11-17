class Urls {
  static const String _baseUrl = 'http://152.42.163.176:2006/api/v1';
  static const String registration = '$_baseUrl/Registration';
  static const String login = '$_baseUrl/Login';
  static const String createTask = '$_baseUrl/createTask';
  static const String newTasks = '$_baseUrl/listTaskByStatus/New';
  static const String completedTask = '$_baseUrl/listTaskByStatus/Completed';
  static const String cancelledTask = '$_baseUrl/listTaskByStatus/Cancelled';
  static const String inProgressTask = '$_baseUrl/listTaskByStatus/In Progress';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatus(String id, String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';
  static String verifyEmail(String email) =>
      '$_baseUrl/RecoverVerifyEmail/$email';
  static String verifyPin(String email, String pin) =>
      '$_baseUrl/RecoverVerifyOtp/$email/$pin';
  static const String resetPassword = '$_baseUrl/RecoverResetPassword';
  static const String updateProfile = '$_baseUrl/ProfileUpdate';
  static const String profileDetails = '$_baseUrl/ProfileDetails';
}
