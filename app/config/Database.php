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

class Database {
    private static $instance = null;
    private $connection;
    
    // Database configuration
    private $host = 'localhost';
    private $db_name = 'elibrary_mobile';
    private $username = 'root';
    private $password = '123';
    private $charset = 'utf8mb4';
    
    /**
     * Private constructor - prevent direct instantiation
     */
    private function __construct() {
        try {
            $dsn = "mysql:host={$this->host};dbname={$this->db_name};charset={$this->charset}";
            
            $this->connection = new PDO($dsn, $this->username, $this->password, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ]);
            
            // Log successful connection
            error_log("[" . date('Y-m-d H:i:s') . "] Database connected successfully\n", 3, __DIR__ . '/../../storage/logs/database.log');
            
        } catch (PDOException $e) {
            // Log error
            error_log("[" . date('Y-m-d H:i:s') . "] Database connection failed: " . $e->getMessage() . "\n", 3, __DIR__ . '/../../storage/logs/error.log');
            die("Database Connection Failed: " . $e->getMessage());
        }
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
            error_log("[" . date('Y-m-d H:i:s') . "] Query error: " . $e->getMessage() . "\n", 3, __DIR__ . '/../../storage/logs/error.log');
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
            error_log("[" . date('Y-m-d H:i:s') . "] Query error: " . $e->getMessage() . "\n", 3, __DIR__ . '/../../storage/logs/error.log');
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
            error_log("[" . date('Y-m-d H:i:s') . "] Execute error: " . $e->getMessage() . "\n", 3, __DIR__ . '/../../storage/logs/error.log');
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
        } catch (Exception $e) {
            return false;
        }
    }
}
?>
