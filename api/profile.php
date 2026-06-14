<?php
require_once __DIR__ . '/base.php';

use App\Models\User;

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, "Method not allowed", null, 405);
}

$authUser = require_auth();

$userModel = new User();
$userProfile = $userModel->getUserWithStats($authUser['id']);

if (!$userProfile) {
    send_json(false, "User not found", null, 404);
}

unset($userProfile['password']);

send_json(true, "Profile retrieved successfully", $userProfile);
?>
