<?php
/**
 * QR Log Model
 */

namespace App\Models;

class QrLog extends Model {
    protected $table = 'qr_logs';

    public function createLog($user_id, $book_id, $scan_type = 'verify', $location = null) {
        return $this->insert([
            'user_id' => $user_id,
            'book_id' => $book_id,
            'scan_type' => $scan_type,
            'location' => $location,
        ]);
    }

    public function getRecentWithDetails($limit = 20) {
        $limit = max(1, (int) $limit);
        $query = "
            SELECT q.*, u.name as user_name, u.nim, b.title as book_title, b.book_code
            FROM {$this->table} q
            JOIN users u ON q.user_id = u.id
            JOIN books b ON q.book_id = b.id
            ORDER BY q.created_at DESC
            LIMIT {$limit}
        ";
        return $this->db->query($query);
    }

    public function countToday() {
        $query = "SELECT COUNT(*) as total FROM {$this->table} WHERE DATE(created_at) = CURDATE()";
        $result = $this->db->queryOne($query);
        return (int) ($result['total'] ?? 0);
    }
}
?>
