<?php
/**
 * Borrowing Model
 */

namespace App\Models;

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
                   u.name as user_name
            FROM {$this->table} br
            LEFT JOIN borrowing_details bd ON br.id = bd.borrowing_id
            LEFT JOIN books b ON bd.book_id = b.id
            LEFT JOIN users u ON br.user_id = u.id
            GROUP BY br.id
            ORDER BY br.borrow_date DESC
        ";
        return $this->db->query($query);
    }
}
?>
