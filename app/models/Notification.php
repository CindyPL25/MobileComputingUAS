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

    public function createForUser($user_id, $title, $message, $type = 'info') {
        return $this->insert([
            'user_id' => $user_id,
            'title' => $title,
            'message' => $message,
            'notification_type' => $type,
            'is_read' => 0,
        ]);
    }

    public function markAsRead($notification_id, $user_id) {
        $query = "
            UPDATE {$this->table}
            SET is_read = 1, read_at = NOW()
            WHERE id = ? AND user_id = ?
        ";
        return $this->db->execute($query, [$notification_id, $user_id]);
    }
}
?>
