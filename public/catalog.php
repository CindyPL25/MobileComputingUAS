<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Load from database
use App\Models\Category;
use App\Models\Book;

$categoryModel = new Category();
$bookModel = new Book();

// Get all categories from database
$categories = $categoryModel->getAll();

// Get books by category if specified
$selected_category = $_GET['category'] ?? null;
if ($selected_category) {
    $books = $bookModel->getByCategory($selected_category);
} else {
    // Get all available books
    $books = $bookModel->getAvailableBooks();
}

$pageTitle = 'Katalog Buku - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
require_once __DIR__ . '/../app/views/pages/catalog-content.php';
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';

