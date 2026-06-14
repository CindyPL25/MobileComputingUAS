<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is admin
requireAdmin();

use App\Models\QrLog;
use App\Models\Book;

$qrLogModel = new QrLog();
$bookModel = new Book();

$qrScans = $qrLogModel->getRecentWithDetails(30);
$books = $bookModel->getAllWithCategory();
$qrScanCountToday = $qrLogModel->countToday();

$pageTitle = 'QR Scan Admin - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'QR Scan';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php require_once __DIR__ . '/../app/views/admin/qr-content.php'; ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

