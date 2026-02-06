class Validators {
  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static String? required(String? v, {String label = 'Field'}) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  static String? email(String? v) {
    final req = required(v, label: 'Email');
    if (req != null) return req;
    if (!_emailRegex.hasMatch(v!.trim())) return 'Format email tidak valid';
    return null;
  }

  static String? otp8AlNumComplex(String? v) {
    final req = required(v, label: 'OTP');
    if (req != null) return req;

    final otp = v!.trim();
    if (otp.length != 8) return 'OTP harus terdiri dari 8 karakter';
    final alnum = RegExp(r'^[a-zA-Z0-9]+$');
    if (!alnum.hasMatch(otp)) {
      return 'OTP harus berupa kombinasi angka dan huruf';
    }

    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(otp);
    final hasDigit = RegExp(r'[0-9]').hasMatch(otp);
    if (!hasLetter || !hasDigit) return 'OTP harus kombinasi angka dan huruf';
    return null;
  }
}
