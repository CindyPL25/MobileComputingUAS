<?php
/**
 * ApiToken Model
 */

namespace App\Models;

class ApiToken extends Model {
    protected $table = 'api_tokens';
    
    /**
     * Create a new API token for a user
     * 
     * @param int $user_id
     * @return string generated token
     */
    public function createToken($user_id) {
        $token = bin2hex(random_bytes(32)); // Generate 64 char hex string
        
        $data = [
            'user_id' => $user_id,
            'token' => $token,
            // Expires in 30 days
            'expires_at' => date('Y-m-d H:i:s', strtotime('+30 days'))
        ];
        
        $this->insert($data);
        return $token;
    }
    
    /**
     * Get user by token
     * 
     * @param string $token
     * @return array|null user data
     */
    public function getUserByToken($token) {
        $query = "
            SELECT u.* 
            FROM users u
            JOIN {$this->table} t ON u.id = t.user_id
            WHERE t.token = ? AND (t.expires_at IS NULL OR t.expires_at > NOW())
        ";
        return $this->db->queryOne($query, [$token]);
    }
    
    /**
     * Revoke token
     * 
     * @param string $token
     * @return bool
     */
    public function revokeToken($token) {
        $query = "DELETE FROM {$this->table} WHERE token = ?";
        return $this->db->execute($query, [$token]);
    }
}
?>
