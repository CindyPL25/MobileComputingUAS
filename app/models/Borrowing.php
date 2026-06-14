<?php
/**
 * Borrowing Model
 */

namespace App\Models;

use RuntimeException;

class Borrowing extends Model {
    protected $table = 'borrowings';
    
    /**
     * Get borrowing with books detail
     */
    public function getBorrowingWithBooks($borrowing_id) {
        $query = "
            SELECT br.*, u.name as user_name, u.nim,
                   GROUP_CONCAT(b.title) as book_titles
            FROM {$this->table} br
            LEFT JOIN users u ON br.user_id = u.id
            LEFT JOIN borrowing_details bd ON br.id = bd.borrowing_id
            LEFT JOIN books b ON bd.book_id = b.id
            WHERE br.id = ?
            GROUP BY br.id
        ";
        return $this->db->queryOne($query, [$borrowing_id]);
    }
    
    /**
     * Get all borrowings by user
     */
    public function getBorrowingsByUser($user_id) {
        $query = "
            SELECT br.*, 
                   GROUP_CONCAT(b.title) as book_titles,
                   COUNT(bd.id) as book_count
            FROM {$this->table} br
            LEFT JOIN borrowing_details bd ON br.id = bd.borrowing_id
            LEFT JOIN books b ON bd.book_id = b.id
            WHERE br.user_id = ?
            GROUP BY br.id
            ORDER BY br.borrow_date DESC
        ";
        return $this->db->query($query, [$user_id]);
    }
    
    /**
     * Get active borrowings by user
     */
    public function getActiveBorrowingsByUser($user_id) {
        $query = "
            SELECT br.*, 
                   GROUP_CONCAT(b.title) as book_titles,
                   COUNT(bd.id) as book_count
            FROM {$this->table} br
            LEFT JOIN borrowing_details bd ON br.id = bd.borrowing_id
            LEFT JOIN books b ON bd.book_id = b.id
            WHERE br.user_id = ? AND br.status IN ('active', 'pending')
            GROUP BY br.id
            ORDER BY br.due_date ASC
        ";
        return $this->db->query($query, [$user_id]);
    }
    
    /**
     * Get borrowing details
     */
    public function getBorrowingDetails($borrowing_id) {
        $query = "
            SELECT bd.*, b.title, b.author, b.cover_image, b.book_code
            FROM borrowing_details bd
            LEFT JOIN books b ON bd.book_id = b.id
            WHERE bd.borrowing_id = ?
        ";
        return $this->db->query($query, [$borrowing_id]);
    }
    
    /**
     * Get all active borrowings (for admin dashboard)
     */
    public function getAllActiveBorrowings() {
        $query = "
            SELECT br.*, u.name, u.nim,
                   GROUP_CONCAT(b.title) as book_titles,
                   COUNT(bd.id) as book_count
            FROM {$this->table} br
            LEFT JOIN users u ON br.user_id = u.id
            LEFT JOIN borrowing_details bd ON br.id = bd.borrowing_id
            LEFT JOIN books b ON bd.book_id = b.id
            WHERE br.status IN ('active', 'pending')
            GROUP BY br.id
            ORDER BY br.due_date ASC
        ";
        return $this->db->query($query);
    }
    
    /**
     * Get overdue borrowings
     */
    public function getOverdueBorrowings() {
        $query = "
            SELECT br.*, u.name, u.nim,
                   GROUP_CONCAT(b.title) as book_titles,
                   DATEDIFF(CURDATE(), br.due_date) as days_overdue
            FROM {$this->table} br
            LEFT JOIN users u ON br.user_id = u.id
            LEFT JOIN borrowing_details bd ON br.id = bd.borrowing_id
            LEFT JOIN books b ON bd.book_id = b.id
            WHERE br.status = 'overdue' OR (br.status = 'active' AND br.due_date < CURDATE())
            GROUP BY br.id
            ORDER BY br.due_date ASC
        ";
        return $this->db->query($query);
    }
    
    /**
     * Get all borrowings for admin with book titles
     */
    public function getAllWithBooks() {
        $query = "
            SELECT br.*, 
                   GROUP_CONCAT(b.title) as book_titles,
                   COUNT(bd.id) as book_count,
                   u.name as user_name,
                   u.nim as user_nim
            FROM {$this->table} br
            LEFT JOIN borrowing_details bd ON br.id = bd.borrowing_id
            LEFT JOIN books b ON bd.book_id = b.id
            LEFT JOIN users u ON br.user_id = u.id
            GROUP BY br.id
            ORDER BY br.borrow_date DESC
        ";
        return $this->db->query($query);
    }

    public function countActive() {
        $query = "SELECT COUNT(*) as total FROM {$this->table} WHERE status IN ('pending', 'active', 'overdue')";
        $result = $this->db->queryOne($query);
        return (int) ($result['total'] ?? 0);
    }

    public function getBorrowingsByUserStructured($user_id) {
        $query = "
            SELECT br.id as borrowing_id, br.borrow_date, br.due_date, br.return_date, br.status, br.fine_amount,
                   bd.id as detail_id, bd.returned_at,
                   b.id as book_id, b.title, b.author, b.cover_image, b.book_code,
                   u.id as user_id, u.name as user_name, u.nim
            FROM {$this->table} br
            JOIN users u ON br.user_id = u.id
            JOIN borrowing_details bd ON br.id = bd.borrowing_id
            JOIN books b ON bd.book_id = b.id
            WHERE br.user_id = ?
            ORDER BY br.borrow_date DESC, br.id DESC
        ";
        $results = $this->db->query($query, [$user_id]);

        $borrowings = [];
        foreach ($results as $row) {
            $borrowing_id = $row['borrowing_id'];

            if (!isset($borrowings[$borrowing_id])) {
                $borrowings[$borrowing_id] = [
                    'id' => $borrowing_id,
                    'user' => [
                        'id' => $row['user_id'],
                        'name' => $row['user_name'],
                        'nim' => $row['nim'],
                    ],
                    'borrow_date' => $row['borrow_date'],
                    'due_date' => $row['due_date'],
                    'return_date' => $row['return_date'],
                    'status' => $row['status'],
                    'fine_amount' => $row['fine_amount'],
                    'books' => [],
                ];
            }

            $borrowings[$borrowing_id]['books'][] = [
                'detail_id' => $row['detail_id'],
                'book_id' => $row['book_id'],
                'title' => $row['title'],
                'author' => $row['author'],
                'cover_image' => $row['cover_image'],
                'book_code' => $row['book_code'],
                'returned_at' => $row['returned_at'],
            ];
        }

        return array_values($borrowings);
    }

    public function createBorrowing($user_id, $book_id, $location = null, $logQr = false) {
        $this->db->beginTransaction();

        try {
            $book = $this->db->queryOne("SELECT * FROM books WHERE id = ? FOR UPDATE", [$book_id]);
            if (!$book) {
                throw new RuntimeException('Buku tidak ditemukan.');
            }

            if ((int) $book['available_stock'] <= 0) {
                throw new RuntimeException('Stok buku sedang kosong.');
            }

            $borrowDate = date('Y-m-d');
            $dueDate = date('Y-m-d', strtotime('+7 days'));

            $this->db->execute(
                "INSERT INTO {$this->table} (user_id, borrow_date, due_date, status) VALUES (?, ?, ?, 'active')",
                [$user_id, $borrowDate, $dueDate]
            );
            $borrowingId = $this->db->lastInsertId();

            $this->db->execute(
                "INSERT INTO borrowing_details (borrowing_id, book_id) VALUES (?, ?)",
                [$borrowingId, $book_id]
            );

            if ($logQr) {
                $this->db->execute(
                    "INSERT INTO qr_logs (user_id, book_id, scan_type, location) VALUES (?, ?, 'borrow', ?)",
                    [$user_id, $book_id, $location]
                );
            }

            $this->db->execute(
                "INSERT INTO notifications (user_id, title, message, notification_type) VALUES (?, ?, ?, 'success')",
                [
                    $user_id,
                    'Peminjaman Berhasil',
                    'Anda berhasil meminjam buku "' . $book['title'] . '". Batas pengembalian: ' . $dueDate . '.',
                ]
            );

            $this->db->commit();
            return $this->getBorrowingWithBooks($borrowingId);
        } catch (\Throwable $e) {
            $this->db->rollback();
            throw $e;
        }
    }

    public function returnBorrowing($borrowing_id, $actor_user_id = null, $location = null, $logQr = false) {
        $this->db->beginTransaction();

        try {
            $borrowing = $this->db->queryOne("SELECT * FROM {$this->table} WHERE id = ? FOR UPDATE", [$borrowing_id]);
            if (!$borrowing) {
                throw new RuntimeException('Data peminjaman tidak ditemukan.');
            }

            if ($borrowing['status'] === 'returned') {
                throw new RuntimeException('Peminjaman ini sudah dikembalikan.');
            }

            $details = $this->getBorrowingDetails($borrowing_id);
            if (empty($details)) {
                throw new RuntimeException('Detail buku peminjaman tidak ditemukan.');
            }

            $this->db->execute(
                "UPDATE {$this->table} SET status = 'returned', return_date = ? WHERE id = ?",
                [date('Y-m-d'), $borrowing_id]
            );

            $this->db->execute(
                "UPDATE borrowing_details SET returned_at = NOW() WHERE borrowing_id = ? AND returned_at IS NULL",
                [$borrowing_id]
            );

            $bookTitles = array_map(fn ($item) => $item['title'], $details);
            $this->db->execute(
                "INSERT INTO notifications (user_id, title, message, notification_type) VALUES (?, ?, ?, 'success')",
                [
                    $borrowing['user_id'],
                    'Pengembalian Berhasil',
                    'Pengembalian buku ' . implode(', ', $bookTitles) . ' berhasil diproses.',
                ]
            );

            if ($logQr) {
                $scannerId = $actor_user_id ?: $borrowing['user_id'];
                foreach ($details as $detail) {
                    $this->db->execute(
                        "INSERT INTO qr_logs (user_id, book_id, scan_type, location) VALUES (?, ?, 'return', ?)",
                        [$scannerId, $detail['book_id'], $location]
                    );
                }
            }

            $this->db->commit();
            return $this->getBorrowingWithBooks($borrowing_id);
        } catch (\Throwable $e) {
            $this->db->rollback();
            throw $e;
        }
    }

    public function borrowByBookCode($user_id, $book_code, $location = null) {
        $book = $this->db->queryOne("SELECT id FROM books WHERE book_code = ?", [$book_code]);
        if (!$book) {
            throw new RuntimeException('Kode QR buku tidak valid.');
        }

        return $this->createBorrowing($user_id, $book['id'], $location, true);
    }

    public function returnByBookCode($user_id, $book_code, $location = null) {
        $query = "
            SELECT br.id
            FROM {$this->table} br
            JOIN borrowing_details bd ON br.id = bd.borrowing_id
            JOIN books b ON bd.book_id = b.id
            WHERE br.user_id = ?
              AND b.book_code = ?
              AND br.status IN ('active', 'overdue', 'pending')
            ORDER BY br.borrow_date ASC
            LIMIT 1
        ";
        $borrowing = $this->db->queryOne($query, [$user_id, $book_code]);
        if (!$borrowing) {
            throw new RuntimeException('Tidak ada peminjaman aktif untuk kode QR ini.');
        }

        return $this->returnBorrowing($borrowing['id'], $user_id, $location, true);
    }
}
?>
