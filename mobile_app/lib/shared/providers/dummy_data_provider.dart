import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';

final authStateProvider = StateProvider<UserModel?>((ref) => null);

final usersProvider = Provider<List<UserModel>>((ref) {
  return [
    UserModel(
      name: 'Cindy Maharani',
      nim: '2304010101',
      email: 'cindy.maharani@student.ac.id',
      major: 'Sistem Informasi',
      status: 'Aktif',
    ),
    UserModel(
      name: 'Raka Pradipta',
      nim: '2304010102',
      email: 'raka.pradipta@student.ac.id',
      major: 'Teknik Informatika',
      status: 'Aktif',
    ),
    UserModel(
      name: 'Nadia Putri',
      nim: '2304010103',
      email: 'nadia.putri@student.ac.id',
      major: 'Sistem Informasi',
      status: 'Nonaktif',
    ),
    UserModel(
      name: 'Bima Saputra',
      nim: '2304010104',
      email: 'bima.saputra@student.ac.id',
      major: 'Teknik Informatika',
      status: 'Aktif',
    ),
  ];
});

final booksProvider = Provider<List<BookModel>>((ref) {
  return [
    BookModel(
        id: 1,
        title: 'Dasar-dasar Pemrograman Web Menggunakan Golang dan ReactJS',
        author: 'Ahmad Fathoni R; Roni Andarsyah',
        category: 'Teknologi',
        publisher: 'Buku Pedia',
        year: '2024',
        isbn: '978-623-88528-5-7',
        status: 'Tersedia',
        cover: 'https://kubuku.id/api/generic/showCover/89122',
        description: 'Panduan praktis membangun aplikasi web modern untuk E-Library menggunakan REST API, Gin Framework Golang, dan ReactJS dengan integrasi antara client dan server.',
        sourceUrl: 'https://e-library.itk.ac.id/detail/dasar-dasar-pemrograman-web-menggunakan-golang-dan-reactjs/89122',
        popular: true,
    ),
    BookModel(
        id: 2,
        title: 'Pengantar Sistem Informasi',
        author: 'Lukman Abdurrahman; Ari Fajar Santoso',
        category: 'Sistem Informasi',
        publisher: 'Tel-U Press',
        year: '2023',
        isbn: '978-623-6484-47-0',
        status: 'Dipinjam',
        cover: 'https://telupress.telkomuniversity.ac.id/storage/cover/B240009_1708970843.png',
        description: 'Buku ini memperkenalkan dasar-dasar Sistem Informasi untuk mahasiswa, mulai dari pengenalan bidang, pemodelan sistem, database, cloud computing, etika TI, keamanan, sampai tata kelola teknologi informasi.',
        sourceUrl: 'https://telupress.telkomuniversity.ac.id/product/pengantar-sistem-informasi/22/16',
        popular: true,
    ),
    BookModel(
        id: 3,
        title: 'Pengantar Basis Data',
        author: 'Arie Gunawan, S.Kom., M.M.S.I.; dkk',
        category: 'Database',
        publisher: 'Literasi Nusantara Abadi',
        year: '2023',
        isbn: '978-623-8246-60-1',
        status: 'Tersedia',
        cover: 'https://kubuku.id/api/generic/showCover/64100',
        description: 'Buku ini membahas pemahaman dasar basis data, jenis basis data, struktur data, model relasional, SQL, normalisasi, integritas referensial, dan transaksi.',
        sourceUrl: 'https://e-library.itk.ac.id/detail/pengantar-basis-data/64100',
        popular: false,
    ),
    BookModel(
        id: 4,
        title: 'Pengembangan Aplikasi Mobile Panduan Langkah-demi-Langkah untuk Pemula',
        author: 'Mufiah Laeliyah',
        category: 'Mobile Computing',
        year: '2024',
        publisher: 'Salim Sanjaya',
        isbn: 'Proses',
        status: 'Tersedia',
        cover: 'https://kubuku.id/api/generic/showCover/94677',
        description: 'Buku digital bertema informatika yang membahas pengembangan aplikasi mobile secara bertahap dan pengenalan bahasa pemrograman untuk pembaca pemula.',
        sourceUrl: 'https://e-library.itk.ac.id/detail/pengembangan-aplikasi-mobile-panduan-langkah-demi-langkah-untuk-pemula/94677',
        popular: true,
    ),
    BookModel(
        id: 5,
        title: 'Analisa dan Perancangan Sistem Informasi',
        author: 'Eva Argarini Pratama; Corie Mei Hellyana; Sutrisno',
        category: 'Sistem Informasi',
        publisher: 'Penerbit Deepublish',
        year: '2020',
        isbn: '978-623-02-1968-9',
        status: 'Dipinjam',
        cover: 'https://img.mbizmarket.co.id/products/thumbs/500x500/2023/10/20/7cababf3881d4334c4fa5722654186c4.jpg',
        description: 'Buku pegangan perkuliahan yang membahas konsep sistem informasi, SDLC, analisa sistem, perancangan, pengkodean, pengujian, basis data, latihan soal, dan studi kasus.',
        sourceUrl: 'https://www.mbizmarket.co.id/catalog/detail/buku-analisa-dan-perancangan-sistem-informasi-4196612-7356736.html',
        popular: false,
    ),
    BookModel(
        id: 6,
        title: 'Membangun dan Menguji Keamanan Website',
        author: 'Hartono; Onno W. Purbo',
        category: 'Keamanan Web',
        publisher: 'Andi Offset',
        year: '2022',
        isbn: '9786230128073',
        status: 'Tersedia',
        cover: 'https://image.gramedia.net/rs%3Afit%3A0%3A0/plain/https%3A//cdn.gramedia.com/uploads/items/Membangun_Dan_Menguji_Keamanan_Website.jpg',
        description: 'Buku ini menjelaskan perlindungan website, cara membangun pertahanan keamanan, serta konsep pengujian dan peretasan agar developer dan tester memahami sudut pandang penyerang.',
        sourceUrl: 'https://www.gramedia.com/products/membangun-dan-menguji-keamanan-website',
        popular: false,
    ),
  ];
});

final historyProvider = Provider<List<HistoryModel>>((ref) {
  return [
    HistoryModel(
        title: 'Pengembangan Aplikasi Mobile Panduan Langkah-demi-Langkah untuk Pemula',
        borrowedAt: '02 Juni 2026',
        returnedAt: '09 Juni 2026',
        status: 'Dikembalikan',
    ),
    HistoryModel(
        title: 'Pengantar Sistem Informasi',
        borrowedAt: '06 Juni 2026',
        returnedAt: '13 Juni 2026',
        status: 'Dipinjam',
    ),
    HistoryModel(
        title: 'Dasar-dasar Pemrograman Web Menggunakan Golang dan ReactJS',
        borrowedAt: '20 Mei 2026',
        returnedAt: '27 Mei 2026',
        status: 'Dikembalikan',
    ),
    HistoryModel(
        title: 'Analisa dan Perancangan Sistem Informasi',
        borrowedAt: '11 Mei 2026',
        returnedAt: '18 Mei 2026',
        status: 'Terlambat',
    ),
  ];
});

final qrScansProvider = Provider<List<QrScanModel>>((ref) {
  return [
    QrScanModel(
      book: 'Dasar-dasar Pemrograman Web Menggunakan Golang dan ReactJS',
      student: 'Cindy Maharani',
      time: '11 Juni 2026, 09:12',
      location: 'Rak Teknologi',
      result: 'Berhasil',
    ),
    QrScanModel(
      book: 'Pengantar Basis Data',
      student: 'Raka Pradipta',
      time: '11 Juni 2026, 10:04',
      location: 'Rak Database',
      result: 'Berhasil',
    ),
    QrScanModel(
      book: 'Membangun dan Menguji Keamanan Website',
      student: 'Bima Saputra',
      time: '10 Juni 2026, 14:35',
      location: 'Rak Keamanan Web',
      result: 'Berhasil',
    ),
  ];
});

final adminUsersProvider = Provider<List<AdminUserModel>>((ref) {
  return [
    AdminUserModel(
      id: 1,
      name: 'Siti Nurhaliza',
      email: 'siti.nurhaliza@kampus.ac.id',
      role: 'Admin Utama',
      createdAt: '01 Januari 2025',
    ),
    AdminUserModel(
      id: 2,
      name: 'Eka Putri Wijaya',
      email: 'eka.putri@kampus.ac.id',
      role: 'Pengelola Buku',
      createdAt: '15 Januari 2025',
    ),
    AdminUserModel(
      id: 3,
      name: 'Ahmad Rahmat',
      email: 'ahmad.rahmat@kampus.ac.id',
      role: 'Operator Sistem',
      createdAt: '20 Februari 2025',
    ),
  ];
});
