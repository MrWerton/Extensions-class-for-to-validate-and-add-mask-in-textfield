//class for to validate field value with regex that is passed in params
class Validator {
  static String? validate(
      String? value, String regexPattern, String errorMessage) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    final regex = RegExp(regexPattern);
    if (!regex.hasMatch(value)) {
      return errorMessage;
    }

    return null;
  }
}
