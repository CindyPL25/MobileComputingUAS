# Mobile E-Library Kampus dengan QR Code

Website dan API E-Library Kampus berbasis PHP Native, MySQL, CSS custom, dan JavaScript sederhana. Backend menangani autentikasi, CRUD admin, peminjaman, pengembalian, notifikasi, API JSON, dan proses QR berbasis `book_code`.

## Fitur

- Login dan register mahasiswa.
- Login admin dengan validasi role dan status akun.
- Dashboard pengguna dan admin dari database.
- Katalog buku dengan pencarian dan filter kategori.
- Detail buku dengan proses peminjaman.
- Validasi, peminjaman, dan pengembalian via QR backend.
- Riwayat peminjaman dan pengembalian.
- CRUD buku, kategori, dan user mahasiswa.
- API PHP Native dengan autentikasi Bearer token.

## Struktur Folder

```text
mobile-elibrary-qr/
|-- public/
|-- app/
|   |-- views/
|   |   |-- layouts/
|   |   |-- components/
|   |   `-- pages/
|   |-- models/
|   |-- config/
|   `-- helpers/
|-- api/
|-- assets/
|   |-- css/
|   |-- js/
|   `-- images/
|-- database/
|-- README.md
`-- .gitignore
```

## Cara Menjalankan di Localhost

1. Letakkan folder `mobile-elibrary-qr` di dalam folder web server, misalnya `htdocs` XAMPP atau `www` Laragon.
2. Import `database/elibrary_mobile.sql`, lalu `database/elibrary_mobile_data.sql`.
3. Pastikan konfigurasi database sesuai `app/config/Database.php` atau environment `DB_HOST`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`.
4. Jalankan Apache dari XAMPP/Laragon.
5. Buka browser ke:

```text
http://localhost/MCUas/mobile-elibrary-qr/public/
```

Jika folder diletakkan langsung di `htdocs`, gunakan:

```text
http://localhost/mobile-elibrary-qr/public/
```

## Catatan

Folder `storage/` berisi file runtime log/session dan akan dibuat otomatis saat aplikasi berjalan .

