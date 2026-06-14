<?php
/**
 * Category Model
 */

namespace App\Models;

class Category extends Model {
    protected $table = 'categories';
    
    /**
     * Get all categories with book count
     */
    public function getAllWithBookCount() {
        $query = "
            SELECT c.*, COUNT(b.id) as book_count
            FROM {$this->table} c
            LEFT JOIN books b ON c.id = b.category_id
            GROUP BY c.id
            ORDER BY c.name
        ";
        return $this->db->query($query);
    }
}
?>
