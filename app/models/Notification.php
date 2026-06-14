<?php
/**
 * Notification Model
 */

namespace App\Models;

class Notification extends Model {
    protected $table = 'notifications';
    
    /**
     * Get notifications by user
     */
    public function getByUserId($user_id) {
        $query = "SELECT * FROM {$this->table} WHERE user_id = ? ORDER BY created_at DESC";
        return $this->db->query($query, [$user_id]);
    }
    
    /**
     * Get unread notifications count
     */
    public function getUnreadCount($user_id) {
        $query = "SELECT COUNT(*) as count FROM {$this->table} WHERE user_id = ? AND is_read = 0";
        $result = $this->db->queryOne($query, [$user_id]);
        return $result['count'] ?? 0;
    }
}
?>
