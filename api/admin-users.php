<?php
require_once __DIR__ . '/base.php';

use App\Models\User;

api_guard(function() {
    $user = require_auth();
    if ($user['role'] !== 'admin') {
        send_json(false, "Forbidden. Admin access required.", null, 403);
    }

    $userModel = new User();
    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === 'GET') {
        $users = $userModel->getAllMahasiswa();
        send_json(true, "Users retrieved successfully", $users);
    } 
    elseif ($method === 'PUT') {
        $input = json_decode(file_get_contents('php://input'), true) ?? [];
        error_log("PUT Payload received: " . print_r($input, true));
        $id = (int) ($input['id'] ?? 0);
        
        try {
            $currentUser = $userModel->getById($id);
            if (!$currentUser) {
                send_json(false, "User tidak ditemukan.", null, 404);
                return;
            }

            $data = [];
            if (isset($input['status'])) {
                $data['status'] = trim($input['status']);
            }
            if (isset($input['role'])) {
                $data['role'] = trim($input['role']);
            }

            if (!empty($data)) {
                $userModel->update($id, $data);
                send_json(true, "User berhasil diperbarui.", $data);
            } else {
                send_json(false, "Tidak ada data yang diperbarui.", null, 400);
            }
        } catch (\Throwable $e) {
            error_log("Error in admin-users.php PUT: " . $e->getMessage() . " on line " . $e->getLine());
            send_json(false, "Gagal memperbarui user: " . $e->getMessage(), null, 500);
        }
    } 
    else {
        send_json(false, "Method not allowed", null, 405);
    }
});
?>
