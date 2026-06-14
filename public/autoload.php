<?php
/**
 * Autoloader untuk App classes
 */

spl_autoload_register(function($class) {
    $prefix = 'App\\';
    $base_dir = __DIR__ . '/../app/';
    
    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0) {
        return;
    }
    
    $relative_class = substr($class, $len);
    $file = $base_dir . str_replace('\\', '/', $relative_class) . '.php';
    
    if (file_exists($file)) {
        require $file;
    }
});

// Start session
session_start();

// Get the currently logged-in user
function getCurrentUser() {
    return $_SESSION['user'] ?? null;
}

// Check if user is logged in
function isLoggedIn() {
    return isset($_SESSION['user']);
}

// Check if user is admin
function isAdmin() {
    $user = getCurrentUser();
    return $user && $user['role'] === 'admin';
}

// Redirect to login if not authenticated
function requireLogin() {
    if (!isLoggedIn()) {
        header('Location: /login.php');
        exit;
    }
}

// Redirect to login if not admin
function requireAdmin() {
    if (!isAdmin()) {
        header('Location: /dashboard.php');
        exit;
    }
}

// Format currency
function formatCurrency($amount) {
    return 'Rp ' . number_format($amount, 0, ',', '.');
}

// Format date
function formatDate($date) {
    return date('d M Y', strtotime($date));
}

// Get borrowing status badge
function getStatusBadge($status) {
    $badges = [
        'pending' => '<span class="badge badge-warning">Pending</span>',
        'active' => '<span class="badge badge-success">Dipinjam</span>',
        'returned' => '<span class="badge badge-primary">Dikembalikan</span>',
        'overdue' => '<span class="badge badge-danger">Terlambat</span>',
    ];
    return $badges[$status] ?? $status;
}

// Get days remaining for borrowing
function getDaysRemaining($due_date) {
    $days = (int)((strtotime($due_date) - time()) / 86400);
    return max($days, 0);
}

?>
