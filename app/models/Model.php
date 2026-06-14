<?php
/**
 * Base Model Class
 * 
 * Menyediakan method dasar untuk operasi CRUD
 */

namespace App\Models;

use App\Config\Database;

class Model {
    protected $table;
    protected $db;
    
    public function __construct() {
        $this->db = Database::getInstance();
    }
    
    /**
     * Get all records dari table
     * 
     * @return array
     */
    public function getAll() {
        $query = "SELECT * FROM {$this->table}";
        return $this->db->query($query);
    }
    
    /**
     * Get record by ID
     * 
     * @param int $id
     * @return array
     */
    public function getById($id) {
        $query = "SELECT * FROM {$this->table} WHERE id = ?";
        return $this->db->queryOne($query, [$id]);
    }
    
    /**
     * Get records with pagination
     * 
     * @param int $page
     * @param int $limit
     * @return array
     */
    public function paginate($page = 1, $limit = 10) {
        $offset = ($page - 1) * $limit;
        $query = "SELECT * FROM {$this->table} LIMIT ? OFFSET ?";
        return $this->db->query($query, [$limit, $offset]);
    }
    
    /**
     * Count total records
     * 
     * @return int
     */
    public function count() {
        $query = "SELECT COUNT(*) as total FROM {$this->table}";
        $result = $this->db->queryOne($query);
        return $result['total'] ?? 0;
    }
    
    /**
     * Insert record
     * 
     * @param array $data
     * @return int insert ID
     */
    public function insert($data) {
        $columns = implode(',', array_keys($data));
        $placeholders = implode(',', array_fill(0, count($data), '?'));
        $query = "INSERT INTO {$this->table} ($columns) VALUES ($placeholders)";
        $this->db->execute($query, array_values($data));
        return $this->db->lastInsertId();
    }
    
    /**
     * Update record
     * 
     * @param int $id
     * @param array $data
     * @return int affected rows
     */
    public function update($id, $data) {
        $updates = [];
        $values = [];
        foreach ($data as $key => $value) {
            $updates[] = "$key = ?";
            $values[] = $value;
        }
        $values[] = $id;
        
        $query = "UPDATE {$this->table} SET " . implode(',', $updates) . " WHERE id = ?";
        return $this->db->execute($query, $values);
    }
    
    /**
     * Delete record
     * 
     * @param int $id
     * @return int affected rows
     */
    public function delete($id) {
        $query = "DELETE FROM {$this->table} WHERE id = ?";
        return $this->db->execute($query, [$id]);
    }
    
    /**
     * Find by condition
     * 
     * @param string $column
     * @param string $value
     * @return array
     */
    public function findBy($column, $value) {
        $query = "SELECT * FROM {$this->table} WHERE $column = ?";
        return $this->db->queryOne($query, [$value]);
    }
    
    /**
     * Find all by condition
     * 
     * @param string $column
     * @param string $value
     * @return array
     */
    public function findAllBy($column, $value) {
        $query = "SELECT * FROM {$this->table} WHERE $column = ?";
        return $this->db->query($query, [$value]);
    }
}
?>
