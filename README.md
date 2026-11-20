# bener.in mobile

Aplikasi Flutter Android untuk platform reparasi bener.in.

## Menjalankan aplikasi

Setup yang digunakan adalah Flutter stable 3.47.9 dengan Dart 3.13.7.
Pasang Android SDK Platform 36 dan NDK 28.2.13676358 melalui Android SDK Manager.
Pastikan `flutter doctor -v` mengenali Android toolchain dan `flutter devices`
menampilkan emulator atau perangkat Android.

```powershell
flutter pub get
flutter run
```

## Verifikasi lokal

```powershell
flutter analyze
flutter test
flutter build apk --debug
```
