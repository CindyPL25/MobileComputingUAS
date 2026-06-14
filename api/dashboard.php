<?php
require_once __DIR__ . '/base.php';

use App\Models\Book;
use App\Models\Category;
use App\Models\User;
use App\Models\Borrowing;

api_guard(function() {
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        send_json(false, "Method not allowed", null, 405);
    }

    require_auth();

    $bookModel = new Book();
    $categoryModel = new Category();
    $userModel = new User();
    $borrowingModel = new Borrowing();

    $totalBooks = $bookModel->count();
    $totalCategories = $categoryModel->count();
    $totalUsers = $userModel->count();

    $totalActiveBorrowings = $borrowingModel->countActive();

    $data = [
        'total_books' => $totalBooks,
        'total_categories' => $totalCategories,
        'total_users' => $totalUsers,
        'total_active_borrowings' => $totalActiveBorrowings
    ];

    send_json(true, "Dashboard stats retrieved successfully", $data);
});
?>
