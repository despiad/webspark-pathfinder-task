sealed class Validators {
  static String? Function(String?) urlValidator = (value) {
    if (value == null) {
      return 'URL is required';
    }
    if (value
        .trim()
        .isEmpty) {
      return 'URL is required';
    }
    if (!(Uri
        .tryParse(value)
        ?.hasAbsolutePath ?? false)) {
      return 'Entered value is not a valid URL';
    }

    return null;
  };
}
