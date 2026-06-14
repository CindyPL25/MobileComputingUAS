<?php
require_once __DIR__ . '/base.php';

use App\Models\Notification;

api_guard(function() {
    $user = require_auth();
    $notificationModel = new Notification();

    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $notifications = $notificationModel->getByUserId($user['id']);
        send_json(true, "Notifications retrieved successfully", $notifications);
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
        $notificationId = $input['id'] ?? null;

        if (!$notificationId) {
            send_json(false, "Notification ID is required", null, 400);
        }

        $notificationModel->markAsRead((int) $notificationId, $user['id']);
        send_json(true, "Notification marked as read");
    }

    send_json(false, "Method not allowed", null, 405);
});
?>
