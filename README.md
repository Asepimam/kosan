# kosan

Ringkasan singkat proyek ini dan instruksi cepat untuk menjalankan backend (Django) dan frontend (Flutter).

**Struktur proyek (terkait)**
- `kosan_backend/` : Django backend
- `kosan_kan/` : Flutter aplikasi (mobile/web/desktop)

**Persyaratan**
- Python 3.10+ (virtualenv direkomendasikan)
- pip
- Flutter SDK (untuk `kosan_kan`)

## Backend (Django)

1. Aktifkan virtual environment di `kosan_backend/env` atau buat baru:

```bash
# dari root proyek
cd kosan_backend
python3 -m venv env
source env/bin/activate
```

2. Install dependency:

```bash
pip install -r requirements.txt
```

3. Apply migrations dan jalankan server:

```bash
python manage.py migrate
python manage.py runserver
```

4. File penting:
- `kosan_backend/settings.py` — konfigurasi Django
- `apps/` — aplikasi Django (mis. `users`, `healt`)

Catatan: Jangan meng-ignore folder `apps/*/migrations` karena migrasi perlu di-track.

## Frontend (Flutter)

1. Masuk ke folder `kosan_kan` lalu jalankan:

```bash
cd kosan_kan
flutter pub get
flutter run
```

2. Untuk build release, gunakan platform-specific build command (Android/iOS/web).

## Testing

- Backend: jalankan test Django dari `kosan_backend/`

```bash
cd kosan_backend
source env/bin/activate
python manage.py test
```

- Frontend: gunakan `flutter test` di `kosan_kan`.

## Konfigurasi lingkungan

- Gunakan file `.env` atau environment variables untuk pengaturan rahasia (SECRET_KEY, DB, dsb.).
- File `.gitignore` sudah ditambahkan di root dan `kosan_backend/` untuk mengabaikan virtualenv, cache, dan file sensitif.

## Contributor / Development notes

- Pastikan untuk menjalankan migrations sebelum menjalankan server.
- Commit migrasi database ke repository.

## Kontak

Jika perlu bantuan lanjut, beri tahu langkah yang ingin diotomasi (commit, CI, dsb.).
