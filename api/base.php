<?php

// Allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Always return JSON
header('Content-Type: application/json');

// Include autoloader from public/
require_once __DIR__ . '/../public/autoload.php';

use App\Models\ApiToken;

/**
 * Send JSON response
 */
function send_json($success, $message, $data = null, $status_code = 200) {
    http_response_code($status_code);
    
    $response = [
        'success' => $success,
        'message' => $message,
    ];
    
    if ($data !== null) {
        $response['data'] = $data;
    }
    
    echo json_encode($response);
    exit;
}

/**
 * Get Bearer token from header
 */
function get_bearer_token() {
    $headers = null;
    
    if (isset($_SERVER['Authorization'])) {
        $headers = trim($_SERVER["Authorization"]);
    } else if (isset($_SERVER['HTTP_AUTHORIZATION'])) {
        $headers = trim($_SERVER["HTTP_AUTHORIZATION"]);
    } elseif (function_exists('apache_request_headers')) {
        $requestHeaders = apache_request_headers();
        $requestHeaders = array_combine(array_map('ucwords', array_keys($requestHeaders)), array_values($requestHeaders));
        if (isset($requestHeaders['Authorization'])) {
            $headers = trim($requestHeaders['Authorization']);
        }
    }
    
    if (!empty($headers)) {
        if (preg_match('/Bearer\s(\S+)/', $headers, $matches)) {
            return $matches[1];
        }
    }
    
    return null;
}

/**
 * Require authentication via Bearer token
 * Returns User array if authenticated, otherwise sends 401 response and exits.
 */
function require_auth() {
    $token = get_bearer_token();
    
    if (!$token) {
        send_json(false, "Unauthorized. Bearer token is missing.", null, 401);
    }
    
    $apiTokenModel = new ApiToken();
    $user = $apiTokenModel->getUserByToken($token);
    
    if (!$user) {
        send_json(false, "Unauthorized. Invalid or expired token.", null, 401);
    }
    
    return $user;
}
?>
