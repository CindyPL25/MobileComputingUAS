<?php
/**
 * Database Connection Class
 * 
 * Mengelola koneksi ke MySQL menggunakan PDO
 * Menyediakan method singleton untuk akses database
 */

namespace App\Config;

use PDO;
use PDOException;
use RuntimeException;
use Throwable;

class Database {
    private static $instance = null;
    private $connection;
    
    private $host;
    private $db_name;
    private $username;
    private $password;
    private $charset;
    
    /**
     * Private constructor - prevent direct instantiation
     */
    private function __construct() {
        $this->host = getenv('DB_HOST') ?: 'localhost';
        $this->db_name = getenv('DB_DATABASE') ?: 'elibrary_mobile';
        $this->username = getenv('DB_USERNAME') ?: 'root';
        $this->password = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : '123';
        $this->charset = getenv('DB_CHARSET') ?: 'utf8mb4';

        try {
            $dsn = "mysql:host={$this->host};dbname={$this->db_name};charset={$this->charset}";
            
            $this->connection = new PDO($dsn, $this->username, $this->password, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ]);
            $this->log('database.log', 'Database connected successfully');
            
        } catch (PDOException $e) {
            $this->log('error.log', 'Database connection failed: ' . $e->getMessage());
            throw new RuntimeException('Database connection failed.', 0, $e);
        }
    }

    private function log($file, $message) {
        $logDir = __DIR__ . '/../../storage/logs';
        if (!is_dir($logDir)) {
            mkdir($logDir, 0775, true);
        }

        error_log("[" . date('Y-m-d H:i:s') . "] {$message}\n", 3, $logDir . '/' . $file);
    }
    
    /**
     * Singleton pattern - get database instance
     * 
     * @return Database
     */
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    /**
     * Get PDO connection
     * 
     * @return PDO
     */
    public function getConnection() {
        return $this->connection;
    }
    
    /**
     * Execute SELECT query
     * 
     * @param string $query
     * @param array $params
     * @return array
     */
    public function query($query, $params = []) {
        try {
            $stmt = $this->connection->prepare($query);
            $stmt->execute($params);
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            $this->log('error.log', 'Query error: ' . $e->getMessage());
            throw $e;
        }
    }
    
    /**
     * Execute SELECT query - single row
     * 
     * @param string $query
     * @param array $params
     * @return array|null
     */
    public function queryOne($query, $params = []) {
        try {
            $stmt = $this->connection->prepare($query);
            $stmt->execute($params);
            return $stmt->fetch();
        } catch (PDOException $e) {
            $this->log('error.log', 'Query error: ' . $e->getMessage());
            throw $e;
        }
    }
    
    /**
     * Execute INSERT/UPDATE/DELETE query
     * 
     * @param string $query
     * @param array $params
     * @return int affected rows
     */
    public function execute($query, $params = []) {
        try {
            $stmt = $this->connection->prepare($query);
            $stmt->execute($params);
            return $stmt->rowCount();
        } catch (PDOException $e) {
            $this->log('error.log', 'Execute error: ' . $e->getMessage());
            throw $e;
        }
    }
    
    /**
     * Get last insert ID
     * 
     * @return string
     */
    public function lastInsertId() {
        return $this->connection->lastInsertId();
    }
    
    /**
     * Begin transaction
     */
    public function beginTransaction() {
        $this->connection->beginTransaction();
    }
    
    /**
     * Commit transaction
     */
    public function commit() {
        $this->connection->commit();
    }
    
    /**
     * Rollback transaction
     */
    public function rollback() {
        $this->connection->rollback();
    }
    
    /**
     * Test database connection
     * 
     * @return bool
     */
    public static function testConnection() {
        try {
            $db = self::getInstance();
            $db->queryOne("SELECT 1");
            return true;
        } catch (Throwable $e) {
            return false;
        }
    }
}
?>
