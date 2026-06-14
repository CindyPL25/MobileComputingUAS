<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is logged in
requireLogin();

// Load borrowing history from database
use App\Models\Borrowing;

$borrowingModel = new Borrowing();
$histories = $borrowingModel->getBorrowingsByUser($_SESSION['user']['id']);

$pageTitle = 'Riwayat Peminjaman - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
?>
<main class="page-shell">
    <section class="page-title">
        <span class="eyebrow">Riwayat</span>
        <h1>Peminjaman buku</h1>
        <p>Pantau daftar peminjaman dan pengembalian buku dalam tampilan yang nyaman di mobile.</p>
    </section>

    <section class="history-list">
        <?php foreach ($histories as $item): ?>
            <article class="history-card">
                <div>
                    <h2><?= e($item['book_titles'] ?? 'Buku tidak diketahui'); ?></h2>
                    <p>Pinjam: <?= e(formatDate($item['borrow_date'])); ?></p>
                    <p>Kembali: <?= e($item['return_date'] ? formatDate($item['return_date']) : 'Belum dikembalikan'); ?></p>
                </div>
                <span class="history-status <?= e(strtolower($item['status'])); ?>"><?= e(ucfirst($item['status'])); ?></span>
            </article>
        <?php endforeach; ?>
    </section>
</main>
<?php
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';

