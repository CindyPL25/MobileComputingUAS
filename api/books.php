<?php
require_once __DIR__ . '/base.php';

use App\Models\Book;

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, "Method not allowed", null, 405);
}

// Require token even for books list
require_auth();

$bookModel = new Book();
// To make it easy for Flutter, we can return all books. If we want we can paginate, but for now we'll just return all.
// Assuming getBooksWithCategory exists, or we just getAll.
$query = "
    SELECT b.*, c.name as category_name 
    FROM books b
    LEFT JOIN categories c ON b.category_id = c.id
    ORDER BY b.created_at DESC
";
$books = $bookModel->db->query($query);

send_json(true, "Books retrieved successfully", $books);
?>
