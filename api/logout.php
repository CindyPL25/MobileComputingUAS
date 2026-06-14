<?php
require_once __DIR__ . '/base.php';

use App\Models\ApiToken;

api_guard(function() {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        send_json(false, "Method not allowed", null, 405);
    }

    require_auth();
    $token = get_bearer_token();

    $apiTokenModel = new ApiToken();
    $apiTokenModel->revokeToken($token);

    send_json(true, "Logout successful");
});
?>
