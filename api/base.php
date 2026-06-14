<?php

// Allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$requestMethod = $_SERVER['REQUEST_METHOD'] ?? 'GET';

// Handle preflight OPTIONS request
if ($requestMethod === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Always return JSON
header('Content-Type: application/json');
ini_set('display_errors', '0');

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
        $response['data'] = normalize_api_media($data);
    }
    
    echo json_encode($response, JSON_UNESCAPED_UNICODE);
    exit;
}

function api_origin(): string {
    $https = !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off';
    $scheme = $https ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'] ?? '127.0.0.1';

    return $scheme . '://' . $host;
}

function api_asset_url(string $path): string {
    $path = ltrim($path, '/');

    if (str_starts_with($path, 'assets/')) {
        return api_origin() . '/' . $path;
    }

    return api_origin() . '/assets/' . $path;
}

function normalize_api_media($value) {
    if (!is_array($value)) {
        return $value;
    }

    foreach ($value as $key => $item) {
        if ($key === 'cover_image' && is_string($item) && $item !== '' && !preg_match('/^https?:\/\//', $item)) {
            $value[$key] = api_asset_url($item);
            continue;
        }

        if (is_array($item)) {
            $value[$key] = normalize_api_media($item);
        }
    }

    return $value;
}

set_exception_handler(function($exception) {
    send_json(false, "Internal server error", [
        'error' => $exception->getMessage(),
    ], 500);
});

register_shutdown_function(function() {
    $error = error_get_last();
    if (!$error) {
        return;
    }

    $fatalTypes = [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR];
    if (in_array($error['type'], $fatalTypes, true)) {
        if (!headers_sent()) {
            http_response_code(500);
            header('Content-Type: application/json');
        }

        echo json_encode([
            'success' => false,
            'message' => 'Internal server error',
            'data' => ['error' => $error['message']],
        ], JSON_UNESCAPED_UNICODE);
    }
});

// Include autoloader from public/ after JSON handlers are ready.
require_once __DIR__ . '/../public/autoload.php';

function api_guard(callable $handler) {
    try {
        $handler();
    } catch (\Throwable $e) {
        send_json(false, "Internal server error", [
            'error' => $e->getMessage(),
        ], 500);
    }
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
    
    $apiTokenModel = new \App\Models\ApiToken();
    $user = $apiTokenModel->getUserByToken($token);
    
    if (!$user) {
        send_json(false, "Unauthorized. Invalid or expired token.", null, 401);
    }
    
    return $user;
}
?>
