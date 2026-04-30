class CurrencyFormatter {
  static String format(int amount) {
    // Simple formatter for Vietnam Dong without intl package
    String result = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.'
    );
    return '$resultđ';
  }
}
