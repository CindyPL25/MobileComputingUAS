<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is admin
requireAdmin();

// Load data from database
use App\Models\Book;
use App\Models\User;
use App\Models\Borrowing;

$bookModel = new Book();
$userModel = new User();
$borrowingModel = new Borrowing();

// Get statistics
$totalBooks = $bookModel->count();
$totalUsers = $userModel->count();
$activeBorrowings = $borrowingModel->getAllActiveBorrowings();
$activeBorrowingsCount = count($activeBorrowings ?? []);

// Get latest borrowings (first 3)
$recentBorrowings = array_slice($activeBorrowings ?? [], 0, 3);

// Placeholder for QR scans (will be implemented later)
$qrScans = [];

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

