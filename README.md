# yb_news

Aplikasi Yb_news baru sampai authentication yaitu register, login dan OTP verification. Saya tadi malam mencoba untuk membuat JSON server menggunakan Node.js namun tidak sesuai dengan harapan saya. Maksud saya menggunakan JSON server agar bisa dinamis dan mirip dengan backend auth yang asli, namun saya berlarut-larut untuk menyelesaikan namun gagal. Saya migrasi ke local JSON sehingga user login dan OTP disimpan di `users.json` dan OTP‑nya dikirim melalui debug console.

## Feature Selesai

- Auth Register
- Auth Login
- OTP Verify

## State Management & Arsitektur

- State management: `flutter_bloc` (Cubit)
- Arsitektur: Clean Architecture (presentation, domain, data)

## Cara Pakai Auth (JSON Lokal)

1. Pastikan file seed user ada di `assets/data/users.json`.
2. Jalankan aplikasi dan login memakai email/password yang ada di file tersebut.
3. Jika `isFirstLogin = true`, aplikasi akan meminta OTP:
   - OTP 4 karakter alphanumeric.
   - OTP dicetak di debug console (lihat log: `DummyEmailService: OTP for ...`).
4. Masukkan OTP di halaman verifikasi.
5. Jika OTP benar, user masuk ke Home dan `isFirstLogin` diset menjadi `false` di storage lokal.
6. User yang register baru akan disimpan di storage lokal (bukan ke file assets).

Catatan:
- File `assets/data/users.json` adalah seed awal dan tidak bisa diubah saat aplikasi berjalan.
- Perubahan data (hasil register, status `isFirstLogin`, OTP) disimpan di local storage.
