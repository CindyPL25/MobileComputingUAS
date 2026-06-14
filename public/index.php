<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Load featured books from database
use App\Models\Book;
use App\Models\Borrowing;
use App\Models\QrLog;

$bookModel = new Book();
$borrowingModel = new Borrowing();
$qrLogModel = new QrLog();
$books = $bookModel->getPopularBooks();
$totalBooks = $bookModel->count();
$activeBorrowingsCount = $borrowingModel->countActive();
$qrScanCountToday = $qrLogModel->countToday();

$pageTitle = 'Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
require_once __DIR__ . '/../app/views/pages/home-content.php';
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';
