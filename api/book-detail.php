<?php
require_once __DIR__ . '/base.php';

use App\Models\Book;

api_guard(function() {
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        send_json(false, "Method not allowed", null, 405);
    }

    require_auth();

    $id = $_GET['id'] ?? null;

    if (!$id) {
        send_json(false, "Book ID is required", null, 400);
    }

    $bookModel = new Book();
    $book = $bookModel->getBookDetail((int) $id);

    if (!$book) {
        send_json(false, "Book not found", null, 404);
    }

    send_json(true, "Book detail retrieved successfully", $book);
});
?>
