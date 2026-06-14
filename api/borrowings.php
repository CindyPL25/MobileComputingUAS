<?php
require_once __DIR__ . '/base.php';

use App\Models\Borrowing;

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    send_json(false, "Method not allowed", null, 405);
}

$user = require_auth();

$borrowingModel = new Borrowing();

// Use the existing method if possible, or write a custom query that returns details
$query = "
    SELECT br.id as borrowing_id, br.borrow_date, br.due_date, br.return_date, br.status, br.fine_amount,
           bd.id as detail_id, bd.returned_at,
           b.id as book_id, b.title, b.author, b.cover_image, b.book_code,
           u.id as user_id, u.name as user_name, u.nim
    FROM borrowings br
    JOIN users u ON br.user_id = u.id
    JOIN borrowing_details bd ON br.id = bd.borrowing_id
    JOIN books b ON bd.book_id = b.id
    WHERE br.user_id = ?
    ORDER BY br.borrow_date DESC
";

$results = $borrowingModel->db->query($query, [$user['id']]);

// Group by borrowing_id so it's structured nicely for the client
$borrowings = [];
foreach ($results as $row) {
    $borrowing_id = $row['borrowing_id'];
    
    if (!isset($borrowings[$borrowing_id])) {
        $borrowings[$borrowing_id] = [
            'id' => $borrowing_id,
            'user' => [
                'id' => $row['user_id'],
                'name' => $row['user_name'],
                'nim' => $row['nim']
            ],
            'borrow_date' => $row['borrow_date'],
            'due_date' => $row['due_date'],
            'return_date' => $row['return_date'],
            'status' => $row['status'],
            'fine_amount' => $row['fine_amount'],
            'books' => []
        ];
    }
    
    $borrowings[$borrowing_id]['books'][] = [
        'detail_id' => $row['detail_id'],
        'book_id' => $row['book_id'],
        'title' => $row['title'],
        'author' => $row['author'],
        'cover_image' => $row['cover_image'],
        'book_code' => $row['book_code'],
        'returned_at' => $row['returned_at']
    ];
}

send_json(true, "Borrowing history retrieved successfully", array_values($borrowings));
?>
