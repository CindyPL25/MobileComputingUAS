<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is admin
requireAdmin();

// Load data from database
use App\Models\Borrowing;

$borrowingModel = new Borrowing();

$successMessage = '';
$errorMessage = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'return') {
        $id = $_POST['id'] ?? 0;
        try {
            $borrowingModel->returnBorrowing($id, $_SESSION['user']['id'], 'Admin Website');
            $successMessage = "Buku berhasil dikembalikan. Stok otomatis bertambah dan notifikasi tersimpan.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal memproses pengembalian: " . $e->getMessage();
        }
    }
}

// Get all borrowings with book titles
$histories = $borrowingModel->getAllWithBooks();

$pageTitle = 'Peminjaman Admin - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'Peminjaman';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php require_once __DIR__ . '/../app/views/admin/borrowings-content.php'; ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

