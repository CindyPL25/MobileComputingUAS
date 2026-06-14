-- =====================================================
-- E-LIBRARY KAMPUS DATABASE SCHEMA
-- MySQL 8.0+
-- Created: 2026-06-13
-- Version: 1.0
-- =====================================================

-- Drop existing database if exists
DROP DATABASE IF EXISTS elibrary_mobile;

-- Create database
CREATE DATABASE elibrary_mobile CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use database
USE elibrary_mobile;

-- =====================================================
-- TABLE: users
-- Menyimpan data pengguna (mahasiswa & admin)
-- =====================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID pengguna unik',
    nim VARCHAR(20) UNIQUE NOT NULL COMMENT 'Nomor Induk Mahasiswa/Admin',
    name VARCHAR(100) NOT NULL COMMENT 'Nama lengkap pengguna',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT 'Email pengguna',
    password VARCHAR(255) NOT NULL COMMENT 'Password ter-hash (bcrypt)',
    role ENUM('mahasiswa', 'admin') NOT NULL DEFAULT 'mahasiswa' COMMENT 'Role pengguna',
    major VARCHAR(100) COMMENT 'Program studi (untuk mahasiswa)',
    status ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif' COMMENT 'Status akun',
    avatar VARCHAR(255) COMMENT 'URL foto profil',
    phone VARCHAR(20) COMMENT 'Nomor telepon',
    address TEXT COMMENT 'Alamat lengkap',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Dibuat pada',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Diupdate pada',
    
    INDEX idx_nim (nim),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabel pengguna sistem';

-- =====================================================
-- TABLE: categories
-- Menyimpan kategori buku
-- =====================================================
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID kategori unik',
    name VARCHAR(100) UNIQUE NOT NULL COMMENT 'Nama kategori',
    description TEXT COMMENT 'Deskripsi kategori',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Dibuat pada',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Diupdate pada',
    
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabel kategori buku';

-- =====================================================
-- TABLE: books
-- Menyimpan data buku di perpustakaan
-- =====================================================
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID buku unik',
    category_id INT NOT NULL COMMENT 'Referensi kategori',
    book_code VARCHAR(50) UNIQUE NOT NULL COMMENT 'Kode buku (untuk QR)',
    title VARCHAR(255) NOT NULL COMMENT 'Judul buku',
    author VARCHAR(100) NOT NULL COMMENT 'Pengarang buku',
    publisher VARCHAR(100) COMMENT 'Penerbit buku',
    publication_year INT COMMENT 'Tahun terbit',
    isbn VARCHAR(20) COMMENT 'ISBN buku',
    description TEXT COMMENT 'Deskripsi/sinopsis buku',
    cover_image VARCHAR(255) COMMENT 'URL gambar cover',
    stock INT NOT NULL DEFAULT 0 COMMENT 'Total stok buku',
    available_stock INT NOT NULL DEFAULT 0 COMMENT 'Stok tersedia (belum dipinjam)',
    qr_code VARCHAR(255) COMMENT 'URL QR code buku',
    is_popular BOOLEAN DEFAULT FALSE COMMENT 'Flag buku populer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Dibuat pada',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Diupdate pada',
    
    CONSTRAINT fk_books_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    
    INDEX idx_category_id (category_id),
    INDEX idx_book_code (book_code),
    INDEX idx_title (title),
    INDEX idx_available_stock (available_stock),
    FULLTEXT INDEX ft_title_author (title, author)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabel buku perpustakaan';

-- =====================================================
-- TABLE: borrowings
-- Menyimpan header transaksi peminjaman
-- =====================================================
CREATE TABLE borrowings (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID transaksi peminjaman',
    user_id INT NOT NULL COMMENT 'Referensi user/mahasiswa',
    borrow_date DATE NOT NULL COMMENT 'Tanggal meminjam',
    due_date DATE NOT NULL COMMENT 'Tanggal harus dikembalikan',
    return_date DATE COMMENT 'Tanggal pengembalian aktual',
    status ENUM('pending', 'active', 'returned', 'overdue') NOT NULL DEFAULT 'pending' COMMENT 'Status peminjaman',
    fine_amount DECIMAL(10, 2) DEFAULT 0 COMMENT 'Denda jika terlambat',
    notes TEXT COMMENT 'Catatan tambahan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Dibuat pada',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Diupdate pada',
    
    CONSTRAINT fk_borrowings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_borrow_date (borrow_date),
    INDEX idx_due_date (due_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabel header transaksi peminjaman';

-- =====================================================
-- TABLE: borrowing_details
-- Menyimpan detail buku per transaksi peminjaman
-- =====================================================
CREATE TABLE borrowing_details (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID detail peminjaman',
    borrowing_id INT NOT NULL COMMENT 'Referensi transaksi peminjaman',
    book_id INT NOT NULL COMMENT 'Referensi buku yang dipinjam',
    returned_at TIMESTAMP NULL COMMENT 'Waktu pengembalian buku',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Dibuat pada',
    
    CONSTRAINT fk_borrowing_details_borrowing FOREIGN KEY (borrowing_id) REFERENCES borrowings(id) ON DELETE CASCADE,
    CONSTRAINT fk_borrowing_details_book FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE RESTRICT,
    
    INDEX idx_borrowing_id (borrowing_id),
    INDEX idx_book_id (book_id),
    UNIQUE KEY unique_borrowing_book (borrowing_id, book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabel detail buku per transaksi peminjaman';

-- =====================================================
-- TABLE: qr_logs
-- Menyimpan log setiap scan QR
-- =====================================================
CREATE TABLE qr_logs (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID log scan QR',
    user_id INT NOT NULL COMMENT 'Referensi user yang scan',
    book_id INT NOT NULL COMMENT 'Referensi buku yang di-scan',
    scan_type ENUM('borrow', 'return', 'verify') NOT NULL DEFAULT 'verify' COMMENT 'Tipe scan (pinjam/kembalikan/verifikasi)',
    location VARCHAR(100) COMMENT 'Lokasi scan (optional)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Waktu scan',
    
    CONSTRAINT fk_qr_logs_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_qr_logs_book FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id),
    INDEX idx_scan_type (scan_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabel log scan QR';

-- =====================================================
-- TABLE: notifications
-- Menyimpan notifikasi untuk pengguna
-- =====================================================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID notifikasi',
    user_id INT NOT NULL COMMENT 'Referensi user penerima',
    title VARCHAR(255) NOT NULL COMMENT 'Judul notifikasi',
    message TEXT NOT NULL COMMENT 'Isi notifikasi',
    notification_type ENUM('info', 'warning', 'error', 'success') DEFAULT 'info' COMMENT 'Tipe notifikasi',
    is_read BOOLEAN DEFAULT FALSE COMMENT 'Status dibaca',
    read_at TIMESTAMP NULL COMMENT 'Waktu dibaca',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Dibuat pada',
    
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabel notifikasi pengguna';

-- =====================================================
-- TABLE: api_tokens
-- Menyimpan token autentikasi API mobile/web client
-- =====================================================
CREATE TABLE api_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID token API',
    user_id INT NOT NULL COMMENT 'Referensi user pemilik token',
    token VARCHAR(128) NOT NULL COMMENT 'Token bearer API',
    expires_at DATETIME NULL COMMENT 'Waktu kedaluwarsa token',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Dibuat pada',

    CONSTRAINT fk_api_tokens_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

    UNIQUE KEY unique_api_token (token),
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabel token API';

-- =====================================================
-- TRIGGER: Update available_stock saat insert borrowing_details aktif
-- =====================================================
DELIMITER $$

CREATE TRIGGER tr_decrease_stock_on_borrow
BEFORE INSERT ON borrowing_details
FOR EACH ROW
BEGIN
    DECLARE borrowing_status VARCHAR(20);
    DECLARE current_available_stock INT;

    SELECT status INTO borrowing_status
    FROM borrowings
    WHERE id = NEW.borrowing_id;

    IF borrowing_status IN ('pending', 'active', 'overdue') THEN
        SELECT available_stock INTO current_available_stock
        FROM books
        WHERE id = NEW.book_id
        FOR UPDATE;

        IF current_available_stock <= 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Available stock is not enough for borrowing';
        END IF;

        UPDATE books 
        SET available_stock = available_stock - 1
        WHERE id = NEW.book_id;
    END IF;
END$$

DELIMITER ;

-- =====================================================
-- TRIGGER: Restore available_stock saat pengembalian buku
-- =====================================================
DELIMITER $$

CREATE TRIGGER tr_increase_stock_on_return
AFTER UPDATE ON borrowings
FOR EACH ROW
BEGIN
    -- Trigger fires only when status changes TO 'returned'
    IF NEW.status = 'returned' AND OLD.status <> 'returned' THEN
        UPDATE books b
        JOIN borrowing_details bd ON bd.book_id = b.id
        SET b.available_stock = LEAST(b.stock, b.available_stock + 1)
        WHERE bd.borrowing_id = NEW.id;
    END IF;
END$$

DELIMITER ;

-- NOTE: tr_increase_stock_on_return implemented - stock automatically restored on book return

-- =====================================================
-- CONSTRAINTS & CHECKS
-- =====================================================

-- Cek: stok tidak boleh negatif dan available_stock tidak boleh > stock
ALTER TABLE books ADD CONSTRAINT chk_available_stock CHECK (stock >= 0 AND available_stock <= stock AND available_stock >= 0);

-- Cek: due_date harus >= borrow_date
ALTER TABLE borrowings ADD CONSTRAINT chk_dates CHECK (due_date >= borrow_date);

-- =====================================================
-- REFERENCE QUERIES FOR BUSINESS LOGIC
-- =====================================================

/*
-- Query: Buku yang sedang dipinjam oleh user
SELECT 
    b.id, b.title, b.author, 
    bd.created_at as borrowed_at,
    br.due_date
FROM borrowing_details bd
JOIN books b ON bd.book_id = b.id
JOIN borrowings br ON bd.borrowing_id = br.id
WHERE br.user_id = ? AND br.status = 'active';

-- Query: Buku yang overdue
SELECT 
    u.name, b.title, br.due_date, 
    DATEDIFF(CURDATE(), br.due_date) as days_overdue
FROM borrowings br
JOIN users u ON br.user_id = u.id
JOIN borrowing_details bd ON br.id = bd.borrowing_id
JOIN books b ON bd.book_id = b.id
WHERE br.status = 'active' AND br.due_date < CURDATE();

-- Query: Buku paling populer
SELECT b.id, b.title, COUNT(bd.id) as borrow_count
FROM books b
LEFT JOIN borrowing_details bd ON b.id = bd.book_id
GROUP BY b.id
ORDER BY borrow_count DESC
LIMIT 10;

-- Query: Stok buku yang rendah (< 5)
SELECT id, title, available_stock FROM books WHERE available_stock < 5;
*/

-- =====================================================
-- END OF SCHEMA
-- =====================================================
