<?php
require_once __DIR__ . '/base.php';

use App\Models\Borrowing;

api_guard(function() {
    $user = require_auth();
    if ($user['role'] !== 'admin') {
        send_json(false, "Forbidden. Admin access required.", null, 403);
    }

    $borrowingModel = new Borrowing();
    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === 'GET') {
        $filter = $_GET['filter'] ?? 'all'; // all | active | returned | overdue

        if ($filter === 'active') {
            $borrowings = $borrowingModel->getAllActiveBorrowings();
        } elseif ($filter === 'overdue') {
            $borrowings = $borrowingModel->getOverdueBorrowings();
        } else {
            $borrowings = $borrowingModel->getAllWithBooks();
        }

        send_json(true, "Borrowings retrieved successfully", $borrowings);
    }

    if ($method === 'PUT') {
        $input = json_decode(file_get_contents('php://input'), true) ?? [];
        $id     = (int) ($input['id'] ?? 0);
        $action = trim($input['action'] ?? '');

        if (!$id) {
            send_json(false, "ID peminjaman wajib diisi.", null, 400);
        }

        try {
            if ($action === 'return') {
                $result = $borrowingModel->returnBorrowing($id, $user['id']);
                send_json(true, "Buku berhasil ditandai dikembalikan.", $result);
            }

            $data = [];
            if (isset($input['status']))      $data['status']      = trim($input['status']);
            if (isset($input['fine_amount'])) $data['fine_amount'] = (float) $input['fine_amount'];
            if (isset($input['notes']))       $data['notes']       = trim($input['notes']);

            if (!empty($data)) {
                $borrowingModel->update($id, $data);
                send_json(true, "Peminjaman berhasil diperbarui.", $data);
            }

            send_json(false, "Tidak ada data yang diperbarui.", null, 400);
        } catch (\Throwable $e) {
            error_log("Error admin-borrowings PUT: " . $e->getMessage());
            send_json(false, "Gagal memperbarui: " . $e->getMessage(), null, 500);
        }
    }

    send_json(false, "Method not allowed", null, 405);
});
?>
