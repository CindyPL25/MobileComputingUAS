<?php
require_once __DIR__ . '/base.php';

use App\Models\Book;

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, "Method not allowed", null, 405);
}

require_auth();

$id = $_GET['id'] ?? null;

if (!$id) {
    send_json(false, "Book ID is required", null, 400);
}

$bookModel = new Book();
$query = "
    SELECT b.*, c.name as category_name 
    FROM books b
    LEFT JOIN categories c ON b.category_id = c.id
    WHERE b.id = ?
";
$book = $bookModel->db->queryOne($query, [$id]);

if (!$book) {
    send_json(false, "Book not found", null, 404);
}

send_json(true, "Book detail retrieved successfully", $book);
?>
