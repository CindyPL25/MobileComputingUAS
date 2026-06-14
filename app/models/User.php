<?php
/**
 * User Model
 */

namespace App\Models;

class User extends Model {
    protected $table = 'users';
    
    /**
     * Get user by NIM
     */
    public function getByNim($nim) {
        return $this->findBy('nim', $nim);
    }
    
    /**
     * Get user by email
     */
    public function getByEmail($email) {
        return $this->findBy('email', $email);
    }
    
    /**
     * Get all mahasiswa
     */
    public function getAllMahasiswa() {
        $query = "SELECT * FROM {$this->table} WHERE role = 'mahasiswa' ORDER BY name";
        return $this->db->query($query);
    }
    
    /**
     * Get all admin
     */
    public function getAllAdmin() {
        $query = "SELECT * FROM {$this->table} WHERE role = 'admin' ORDER BY name";
        return $this->db->query($query);
    }
    
    /**
     * Get user with borrowing statistics
     */
    public function getUserWithStats($id) {
        $query = "
            SELECT u.*,
                   COUNT(DISTINCT b.id) as total_borrowed,
                   SUM(CASE WHEN b.status = 'active' THEN 1 ELSE 0 END) as active_borrowing,
                   SUM(CASE WHEN b.status = 'overdue' THEN 1 ELSE 0 END) as overdue_count
            FROM {$this->table} u
            LEFT JOIN borrowings b ON u.id = b.user_id
            WHERE u.id = ?
            GROUP BY u.id
        ";
        return $this->db->queryOne($query, [$id]);
    }
}
?>
