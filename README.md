# ♻️ bener.in Mobile

## Application Overview

bener.in Mobile adalah aplikasi Flutter Android yang melanjutkan proyek web PTS
bener.in. Customer dapat menemukan tempat reparasi, mengajukan perbaikan ke
Mitra Reparasi, dan memantau hasilnya. Aplikasi ini mendukung prinsip
*repair before replace* untuk memperpanjang masa pakai barang.

## Daftar Modul dan Pembagian

- **A · Autentikasi & Profil Pengguna — Hisyam.** Registrasi, login, dan
  pengelolaan profil untuk Customer dan Mitra.
- **B · Repair Request & Tracking — Akmal.** Customer mengajukan dan memantau
  permintaan. Mitra yang dituju menangani permintaan dan memperbarui status
  reparasi.
- **C · Profil Mitra Reparasi — Hafizh.** Mitra mengelola informasi usaha,
  layanan, alamat, dan kontak. Customer dapat melihat detail usaha sebelum
  mengajukan permintaan.
- **D · Repair Location & Discovery — Dave.** Pengguna mencari mitra dan
  tempat reparasi lewat peta OpenStreetMap. Customer dapat menyimpan tempat
  pilihan.
- **E · Review & Impact Tracker — Aufa.** Customer memberi ulasan setelah
  reparasi selesai dan melihat jumlah reparasi berhasil serta progres badge.

## Role Pengguna

- **Customer** mencari tempat reparasi, mengajukan dan memantau permintaan,
  menyimpan tempat, serta memberi ulasan setelah reparasi selesai.
- **Mitra Reparasi** mengelola profil usaha dan memperbarui permintaan
  reparasi yang ditujukan kepadanya.

## Integrasi dengan Web PTS

Flutter bertukar data JSON melalui Django REST Framework. Data akun, mitra,
permintaan, dan ulasan tersimpan di database Django yang juga dipakai web PTS.
Sesi Django menentukan akun dan peran untuk membatasi akses ke permintaan dan
Impact. Profil Mitra, hasil pencarian, dan permintaan memakai ID
`MitraReparasi` yang sama.

- [Repositori backend Django](https://github.com/PBP-D-Kelompok-11/bener-in)
- [Website PTS di PWS](https://hisyam-prasetyo-benerin.pws.cs.ui.ac.id/)

## Scope Checkpoint 1

Setiap modul ditargetkan punya minimal satu halaman yang dapat dibuka lewat
navigasi Flutter dan endpoint DRF yang berjalan dengan data Django.
Kumpulkan [tautan repositori Flutter](https://github.com/PBP-D-Kelompok-11/bener-in-mobile)
ke SCELE untuk Checkpoint 1.

### Endpoint DRF Checkpoint 1

Endpoint berikut sudah diuji menggunakan server Django lokal dengan
[commit backend Checkpoint 1](https://github.com/PBP-D-Kelompok-11/bener-in/commit/dd2294c842d1286d0bc3194171e1fe014e0b0ddc).
Ketersediaan API di PWS mengikuti versi backend yang dideploy.

- **A · Autentikasi**
  - `GET /api/v1/auth/csrf/` untuk mengambil token CSRF.
  - `POST /api/v1/auth/login/` untuk memulai sesi.
  - `GET /api/v1/auth/me/` untuk membaca akun yang sedang masuk.
  - `POST /api/v1/auth/logout/` untuk mengakhiri sesi.
- **B · Permintaan.** `GET /api/v1/repairs/` mengembalikan permintaan milik Customer atau
  permintaan yang ditujukan ke Mitra yang masuk.
- **C · Profil Mitra.** `GET /api/v1/mitra/{id}/` mengembalikan detail Mitra aktif.
- **D · Pencarian lokasi.** `GET /api/v1/locations/mitra/` mengembalikan mitra terdekat berdasarkan
  `lat` dan `lng`, dengan `radius_km` dan `category` opsional.
- **E · Impact.** `GET /api/v1/impact/` mengembalikan progres Customer berdasarkan jumlah
  permintaannya yang berstatus `completed`.

## Setup dan Instalasi Lokal

### Backend Django

Jalankan perintah berikut dari repo web `bener-in` di PowerShell. Langkah ini
memasang dependensi, menyiapkan SQLite lokal, dan menjalankan tes API A–E.

```powershell
python -m venv env
.\env\Scripts\python.exe -m pip install -r requirements.txt
$env:PRODUCTION = 'False'
.\env\Scripts\python.exe manage.py migrate
.\env\Scripts\python.exe manage.py test mobile_api
.\env\Scripts\python.exe manage.py runserver 127.0.0.1:8000
```

Tes memakai database sementara. Untuk demo manual dengan SQLite lokal,
buat akun Customer dan Mitra lewat halaman registrasi web. Mitra di sekitar
Depok akan muncul dalam pencarian awal. Data permintaan dan Impact mengikuti
data yang dibuat pada server tersebut.

### Flutter Android

Setup yang digunakan adalah Flutter stable 3.47.9 dengan Dart 3.13.7.
Pasang Android SDK Platform 36 dan NDK 28.2.13676358 melalui Android SDK Manager.
Pastikan `flutter doctor -v` mengenali Android toolchain dan `flutter devices`
menampilkan emulator atau perangkat Android.

Buka terminal kedua di repo `bener-in-mobile`. Dengan satu perangkat Android
atau emulator aktif, teruskan port Django melalui ADB:

```powershell
flutter pub get
& "$env:ANDROID_HOME\platform-tools\adb.exe" reverse tcp:8000 tcp:8000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

Jalankan `flutter run` tanpa `API_BASE_URL` untuk memakai alamat PWS web
bener.in. Setelah deploy, cek endpoint CSRF dan pencarian Mitra di PWS
sebelum mencoba login dari aplikasi:

```powershell
$pws = 'https://hisyam-prasetyo-benerin.pws.cs.ui.ac.id'
Invoke-RestMethod "$pws/api/v1/auth/csrf/"
Invoke-RestMethod "$pws/api/v1/locations/mitra/?lat=-6.36&lng=106.83"
```

## Menjalankan Testing

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

## Desain dan APK

- **Desain mobile (Figma)** · Tautan menyusul.
- **APK** · Tautan menyusul setelah rilis.

## Anggota Kelompok

Kelompok 11 PBP-D

- 2506548295 — Muhammad Akmal Haqqani
- 2506656500 — Aufa Nurcahyo
- 2506614763 — Hisyam Prasetyo
- 2506656785 — Hafizh Zuhdi Hartanto
- 2506656601 — Dave Wesley Tjoeng
