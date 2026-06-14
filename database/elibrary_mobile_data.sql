-- =====================================================
-- ELIBRARY MOBILE - INITIAL DATA MIGRATION
-- This migration inserts initial data for local development and verification
-- =====================================================

USE elibrary_mobile;

-- =====================================================
-- 1. INSERT CATEGORIES
-- =====================================================
INSERT INTO categories (name, description) VALUES
('Fiksi', 'Buku-buku cerita fiksi dan novel'),
('Teknologi', 'Buku-buku tentang teknologi dan programming'),
('Bisnis', 'Buku-buku tentang bisnis dan entrepreneurship'),
('Seni', 'Buku-buku tentang seni, desain, dan fotografi');

-- =====================================================
-- 2. INSERT USERS (Mahasiswa + Admin)
-- Note: Password harus di-hash dengan bcrypt di application layer
-- Untuk testing, gunakan hash yang sudah diprepare
-- =====================================================

-- Password untuk semua demo user: "password123" (akan di-hash di app)
-- Bcrypt hash untuk password123: $2y$10$AXpASSzdYOkcQ8vqz/KYeO5I1QMIEn6h6m9uSbOsZMW2W1P1GOWaO

INSERT INTO users (nim, name, email, password, role, major, status, avatar) VALUES
-- Mahasiswa
('2201001', 'Cindy Maharani', 'cindy@student.ac.id', '$2y$10$AXpASSzdYOkcQ8vqz/KYeO5I1QMIEn6h6m9uSbOsZMW2W1P1GOWaO', 'mahasiswa', 'Teknik Informatika', 'aktif', 'https://ui-avatars.com/api/?name=Cindy+Maharani'),
('2201002', 'Raka Pradipta', 'raka@student.ac.id', '$2y$10$AXpASSzdYOkcQ8vqz/KYeO5I1QMIEn6h6m9uSbOsZMW2W1P1GOWaO', 'mahasiswa', 'Sistem Informasi', 'aktif', 'https://ui-avatars.com/api/?name=Raka+Pradipta'),
('2201003', 'Nadia Putri', 'nadia@student.ac.id', '$2y$10$AXpASSzdYOkcQ8vqz/KYeO5I1QMIEn6h6m9uSbOsZMW2W1P1GOWaO', 'mahasiswa', 'Teknik Komputer', 'aktif', 'https://ui-avatars.com/api/?name=Nadia+Putri'),
('2201004', 'Bima Saputra', 'bima@student.ac.id', '$2y$10$AXpASSzdYOkcQ8vqz/KYeO5I1QMIEn6h6m9uSbOsZMW2W1P1GOWaO', 'mahasiswa', 'Teknik Informatika', 'aktif', 'https://ui-avatars.com/api/?name=Bima+Saputra'),

-- Admin
('A001', 'Siti Nurhaliza', 'siti@admin.ac.id', '$2y$10$AXpASSzdYOkcQ8vqz/KYeO5I1QMIEn6h6m9uSbOsZMW2W1P1GOWaO', 'admin', NULL, 'aktif', 'https://ui-avatars.com/api/?name=Siti+Nurhaliza'),
('A002', 'Eka Putri Wijaya', 'eka@admin.ac.id', '$2y$10$AXpASSzdYOkcQ8vqz/KYeO5I1QMIEn6h6m9uSbOsZMW2W1P1GOWaO', 'admin', NULL, 'aktif', 'https://ui-avatars.com/api/?name=Eka+Putri+Wijaya'),
('A003', 'Ahmad Rahmat', 'ahmad@admin.ac.id', '$2y$10$AXpASSzdYOkcQ8vqz/KYeO5I1QMIEn6h6m9uSbOsZMW2W1P1GOWaO', 'admin', NULL, 'aktif', 'https://ui-avatars.com/api/?name=Ahmad+Rahmat');

-- =====================================================
-- 3. INSERT BOOKS
-- =====================================================

INSERT INTO books (category_id, book_code, title, author, publisher, publication_year, isbn, description, cover_image, stock, available_stock, is_popular) VALUES

-- Teknologi
(2, 'TECH001', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, '978-0132350884', 
'Panduan lengkap menulis code yang clean dan mudah dipahami oleh developer lain.', 
'images/books/pemrograman-web-modern.png', 3, 3, TRUE),

(2, 'TECH002', 'The Pragmatic Programmer', 'David Thomas, Andrew Hunt', 'Addison-Wesley', 2019, '978-0201616224',
'Buku klasik tentang best practices dalam programming dan software development.',
'images/books/mobile-computing-essentials.png', 2, 2, TRUE),

(2, 'TECH003', 'Design Patterns', 'Gang of Four', 'Addison-Wesley', 1994, '978-0201633610',
'Referensi definitif untuk design patterns dalam object-oriented programming.',
'images/books/analisis-desain-sistem.png', 2, 2, FALSE),

-- Bisnis
(3, 'BIZ001', 'Thinking, Fast and Slow', 'Daniel Kahneman', 'Farrar, Straus and Giroux', 2011, '978-0374275631',
'Analisis mendalam tentang bagaimana cara berpikir manusia mempengaruhi keputusan bisnis.',
'images/books/sistem-informasi-perpustakaan.png', 4, 4, TRUE),

-- Fiksi
(1, 'FIC001', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', 1925, '978-0743273565',
'Novel klasik Amerika tentang cinta, ambisi, dan mimpi di era Jazz.',
'images/books/basis-data-pemula.png', 2, 2, FALSE),

(1, 'FIC002', 'To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott', 1960, '978-0061120084',
'Cerita tentang perjuangan keadilan dan integritas moral dalam masyarakat yang rasial.',
'images/books/keamanan-aplikasi-web.png', 1, 1, FALSE);

-- =====================================================
-- 4. INSERT BORROWINGS & BORROWING_DETAILS
-- Transaksi peminjaman awal
-- =====================================================

-- Cindy Maharani (user_id = 1) - pinjam Clean Code & The Pragmatic Programmer
INSERT INTO borrowings (user_id, borrow_date, due_date, return_date, status) VALUES
(1, '2026-05-15', '2026-05-22', NULL, 'active');

INSERT INTO borrowing_details (borrowing_id, book_id) VALUES
(1, 1), -- Clean Code
(1, 2); -- The Pragmatic Programmer

-- Raka Pradipta (user_id = 2) - pinjam Thinking, Fast and Slow (sudah dikembalikan)
INSERT INTO borrowings (user_id, borrow_date, due_date, return_date, status) VALUES
(2, '2026-05-01', '2026-05-08', '2026-05-08', 'returned');

INSERT INTO borrowing_details (borrowing_id, book_id) VALUES
(2, 4); -- Thinking, Fast and Slow

-- Nadia Putri (user_id = 3) - pinjam Design Patterns
INSERT INTO borrowings (user_id, borrow_date, due_date, return_date, status) VALUES
(3, '2026-05-20', '2026-05-27', NULL, 'active');

INSERT INTO borrowing_details (borrowing_id, book_id) VALUES
(3, 3); -- Design Patterns

-- Bima Saputra (user_id = 4) - pinjam The Great Gatsby (overdue)
INSERT INTO borrowings (user_id, borrow_date, due_date, return_date, status) VALUES
(4, '2026-05-01', '2026-05-08', NULL, 'overdue');

INSERT INTO borrowing_details (borrowing_id, book_id) VALUES
(4, 5); -- The Great Gatsby

-- =====================================================
-- 5. INSERT QR_LOGS
-- Log scan QR awal
-- =====================================================

INSERT INTO qr_logs (user_id, book_id, scan_type, location, created_at) VALUES
(1, 1, 'borrow', 'Library Front Desk', '2026-05-15 14:30:00'),
(2, 5, 'return', 'Library Front Desk', '2026-05-08 10:15:00'),
(1, 2, 'verify', 'Library Stacks', '2026-05-16 11:45:00');

-- =====================================================
-- 6. INSERT INITIAL NOTIFICATIONS
-- =====================================================

INSERT INTO notifications (user_id, title, message, notification_type, is_read) VALUES
(1, 'Pengingat Pengembalian', 'Buku "Clean Code" harus dikembalikan pada 2026-05-22', 'warning', FALSE),
(4, 'Buku Overdue', 'Buku "The Great Gatsby" sudah melewati tanggal pengembalian', 'error', TRUE),
(3, 'Peminjaman Berhasil', 'Anda telah berhasil meminjam buku "Design Patterns"', 'success', TRUE);

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Lihat semua user yang terdaftar
-- SELECT * FROM users;

-- Lihat semua buku dengan kategori
-- SELECT b.id, b.title, c.name as category, b.available_stock FROM books b JOIN categories c ON b.category_id = c.id;

-- Lihat peminjaman aktif
-- SELECT u.name, b.title, br.borrow_date, br.due_date FROM borrowings br JOIN users u ON br.user_id = u.id JOIN borrowing_details bd ON br.id = bd.borrowing_id JOIN books b ON bd.book_id = b.id WHERE br.status = 'active';

-- =====================================================
-- END OF INITIAL DATA MIGRATION
-- =====================================================
