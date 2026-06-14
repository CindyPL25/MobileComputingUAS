<?php
require_once __DIR__ . '/base.php';

use App\Models\Borrowing;

api_guard(function() {
    $user = require_auth();
    $borrowingModel = new Borrowing();
    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === 'GET') {
        $borrowings = $borrowingModel->getBorrowingsByUserStructured($user['id']);
        send_json(true, "Borrowing history retrieved successfully", $borrowings);
    }

    if ($method === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
        $bookId = $input['book_id'] ?? null;
        $bookCode = $input['book_code'] ?? null;
        $action = $input['action'] ?? 'borrow';
        $location = $input['location'] ?? 'API';

        if ($action === 'return') {
            if (!$bookCode) {
                send_json(false, "book_code is required for return action", null, 400);
            }

            $borrowing = $borrowingModel->returnByBookCode($user['id'], $bookCode, $location);
            send_json(true, "Book returned successfully", $borrowing);
        }

        if ($bookCode) {
            $borrowing = $borrowingModel->borrowByBookCode($user['id'], $bookCode, $location);
            send_json(true, "Book borrowed successfully", $borrowing);
        }

        if (!$bookId) {
            send_json(false, "book_id or book_code is required", null, 400);
        }

        $borrowing = $borrowingModel->createBorrowing($user['id'], (int) $bookId);
        send_json(true, "Book borrowed successfully", $borrowing);
    }

    send_json(false, "Method not allowed", null, 405);
});
?>
