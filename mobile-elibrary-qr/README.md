# Mobile E-Library Kampus dengan QR Code

Project frontend awal untuk website/mobile web perpustakaan kampus berbasis QR Code. Aplikasi dibuat dengan PHP native, CSS custom, JavaScript sederhana, dan data dummy agar mudah dikembangkan ke backend atau database.

## Fitur Frontend

- Landing page dengan hero dan fitur utama.
- Login dan register dummy.
- Dashboard pengguna dengan statistik dan rekomendasi buku.
- Katalog buku dengan search dan filter kategori dummy.
- Detail buku dengan QR Code placeholder.
- Simulasi scan QR Code.
- Riwayat peminjaman mobile friendly.
- Profil pengguna dummy.
- Bottom navigation khusus mobile.

## Struktur Folder

```text
mobile-elibrary-qr/
|-- public/
|-- app/
|   |-- views/
|   |   |-- layouts/
|   |   |-- components/
|   |   `-- pages/
|   |-- data/
|   `-- helpers/
|-- assets/
|   |-- css/
|   |-- js/
|   |-- images/
|   `-- qr/
|-- README.md
`-- .gitignore
```

## Cara Menjalankan di Localhost

1. Letakkan folder `mobile-elibrary-qr` di dalam folder web server, misalnya `htdocs` XAMPP atau `www` Laragon.
2. Jalankan Apache dari XAMPP/Laragon.
3. Buka browser ke:

```text
http://localhost/MCUas/mobile-elibrary-qr/public/
```

Jika folder diletakkan langsung di `htdocs`, gunakan:

```text
http://localhost/mobile-elibrary-qr/public/
```

## Catatan

Project ini masih tahap frontend. Belum ada database, autentikasi asli, upload gambar, atau proses peminjaman yang tersimpan. Data buku dan riwayat masih memakai array dummy di folder `app/data`.

