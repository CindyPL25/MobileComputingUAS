<?php
require_once __DIR__ . '/base.php';

use App\Models\Book;

api_guard(function() {
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        send_json(false, "Method not allowed", null, 405);
    }

    // Require token even for books list
    require_auth();

    $bookModel = new Book();
    $books = $bookModel->getRecentWithCategory(100);

    send_json(true, "Books retrieved successfully", $books);
});
?>
