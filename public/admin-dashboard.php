<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is admin
requireAdmin();

// Load data from database
use App\Models\Book;
use App\Models\User;
use App\Models\Borrowing;
use App\Models\QrLog;

$bookModel = new Book();
$userModel = new User();
$borrowingModel = new Borrowing();
$qrLogModel = new QrLog();

// Get statistics
$totalBooks = $bookModel->count();
$totalUsers = $userModel->count();
$activeBorrowings = $borrowingModel->getAllActiveBorrowings();
$activeBorrowingsCount = count($activeBorrowings ?? []);
$returnedBorrowings = array_filter($borrowingModel->getAllWithBooks(), fn ($item) => $item['status'] === 'returned');
$qrScans = $qrLogModel->getRecentWithDetails(5);
$qrScanCountToday = $qrLogModel->countToday();

// Get latest borrowings (first 3)
$recentBorrowings = array_slice($activeBorrowings ?? [], 0, 3);

$pageTitle = 'Dashboard Admin - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'Dashboard Admin';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php 
        // Prepare data for view
        $books = $bookModel->getAll();
        $histories = $recentBorrowings;
        $users = $userModel->getAll();
        require_once __DIR__ . '/../app/views/admin/dashboard-content.php'; 
        ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

