<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is logged in
requireLogin();

// Load from database
use App\Models\Book;
use App\Models\Borrowing;

$bookModel = new Book();
$borrowingModel = new Borrowing();

// Get popular books
$books = $bookModel->getPopularBooks();

// Get user's active borrowings
$borrowings = $borrowingModel->getActiveBorrowingsByUser($_SESSION['user']['id']);

// Get user data for display
$user = $_SESSION['user'];

$pageTitle = 'Dashboard - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
require_once __DIR__ . '/../app/views/pages/dashboard-content.php';
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';

