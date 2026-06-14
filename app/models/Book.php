<?php
/**
 * Book Model
 */

namespace App\Models;

class Book extends Model {
    protected $table = 'books';
    
    /**
     * Get all books with category info
     */
    public function getAllWithCategory() {
        $query = "
            SELECT b.*, c.name as category_name
            FROM {$this->table} b
            LEFT JOIN categories c ON b.category_id = c.id
            ORDER BY b.title
        ";
        return $this->db->query($query);
    }
    
    /**
     * Get popular books (is_popular = true)
     */
    public function getPopularBooks() {
        $query = "
            SELECT b.*, c.name as category_name
            FROM {$this->table} b
            LEFT JOIN categories c ON b.category_id = c.id
            WHERE b.is_popular = true
            ORDER BY b.title
        ";
        return $this->db->query($query);
    }
    
    /**
     * Get books by category
     */
    public function getByCategory($category_id) {
        $query = "
            SELECT b.*, c.name as category_name
            FROM {$this->table} b
            LEFT JOIN categories c ON b.category_id = c.id
            WHERE b.category_id = ?
            ORDER BY b.title
        ";
        return $this->db->query($query, [$category_id]);
    }
    
    /**
     * Get available books (stok > 0)
     */
    public function getAvailableBooks() {
        $query = "
            SELECT b.*, c.name as category_name
            FROM {$this->table} b
            LEFT JOIN categories c ON b.category_id = c.id
            WHERE b.available_stock > 0
            ORDER BY b.title
        ";
        return $this->db->query($query);
    }
    
    /**
     * Search books by title or author
     */
    public function search($keyword) {
        $keyword = "%{$keyword}%";
        $query = "
            SELECT b.*, c.name as category_name
            FROM {$this->table} b
            LEFT JOIN categories c ON b.category_id = c.id
            WHERE b.title LIKE ? OR b.author LIKE ?
            ORDER BY b.title
        ";
        return $this->db->query($query, [$keyword, $keyword]);
    }
    
    /**
     * Get book with full info including borrowing history
     */
    public function getBookDetail($id) {
        $query = "
            SELECT b.*, c.name as category_name,
                   COUNT(br.id) as total_borrowed
            FROM {$this->table} b
            LEFT JOIN categories c ON b.category_id = c.id
            LEFT JOIN borrowing_details bd ON b.id = bd.book_id
            LEFT JOIN borrowings br ON bd.borrowing_id = br.id
            WHERE b.id = ?
            GROUP BY b.id
        ";
        return $this->db->queryOne($query, [$id]);
    }
}
?>
