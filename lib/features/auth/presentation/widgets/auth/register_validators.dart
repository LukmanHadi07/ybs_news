class RegisterValidators {
  const RegisterValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static final RegExp _passwordHasLetter = RegExp(r'[A-Za-z]');
  static final RegExp _passwordHasNumber = RegExp(r'[0-9]');

  static String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Nama lengkap wajib diisi';
    if (name.length < 3) return 'Nama lengkap minimal 3 karakter';
    return null;
  }

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email wajib diisi';
    if (!_emailRegex.hasMatch(email)) return 'Format email tidak valid';
    return null;
  }

  static String? validateConfirmEmail(String? value, String email) {
    final confirm = value?.trim() ?? '';
    if (confirm.isEmpty) return 'Konfirmasi email wajib diisi';
    if (confirm.toLowerCase() != email.trim().toLowerCase()) {
      return 'Email tidak sama';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password wajib diisi';
    if (password.length < 8) return 'Password minimal 8 karakter';
    if (!_passwordHasLetter.hasMatch(password) ||
        !_passwordHasNumber.hasMatch(password)) {
      return 'Password harus kombinasi huruf dan angka';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    final confirm = value ?? '';
    if (confirm.isEmpty) return 'Konfirmasi password wajib diisi';
    if (confirm != password) return 'Password tidak sama';
    return null;
  }
}
