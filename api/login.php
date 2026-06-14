<?php
require_once __DIR__ . '/base.php';

use App\Models\User;
use App\Models\ApiToken;

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    send_json(false, "Method not allowed", null, 405);
}

// Get JSON input or POST data
$input = json_decode(file_get_contents('php://input'), true) ?? $_POST;

$identity = $input['email'] ?? $input['identity'] ?? null;
$password = $input['password'] ?? null;

if (empty($identity) || empty($password)) {
    send_json(false, "Email/NIM and password are required", null, 400);
}

$userModel = new User();
$user = $userModel->getByNim($identity) ?? $userModel->getByEmail($identity);

if (!$user || !password_verify($password, $user['password'])) {
    send_json(false, "Invalid credentials", null, 401);
}

if ($user['status'] !== 'aktif') {
    send_json(false, "Your account is disabled", null, 403);
}

// Generate Token
$apiTokenModel = new ApiToken();
$token = $apiTokenModel->createToken($user['id']);

// Remove password from response
unset($user['password']);

// Append token to response
$user['token'] = $token;

send_json(true, "Login successful", $user);
?>
