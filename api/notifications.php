<?php
require_once __DIR__ . '/base.php';

use App\Models\Notification;

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, "Method not allowed", null, 405);
}

$user = require_auth();

$notificationModel = new Notification();
$notifications = $notificationModel->getByUserId($user['id']);

send_json(true, "Notifications retrieved successfully", $notifications);
?>
