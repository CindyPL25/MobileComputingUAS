<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

requireLogin();

use App\Models\Book;
use App\Models\Borrowing;
use App\Models\QrLog;

$bookModel = new Book();
$borrowingModel = new Borrowing();
$qrLogModel = new QrLog();

$successMessage = '';
$errorMessage = '';
$scannedBook = null;
$bookCode = trim($_POST['book_code'] ?? $_GET['book_code'] ?? '');
$action = $_POST['action'] ?? 'verify';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ($bookCode === '') {
        $errorMessage = 'Kode QR buku harus diisi.';
    } else {
        try {
            if ($action === 'borrow') {
                $borrowing = $borrowingModel->borrowByBookCode($_SESSION['user']['id'], $bookCode, 'Website QR');
                $successMessage = 'Peminjaman via QR berhasil. Batas kembali: ' . formatDate($borrowing['due_date']) . '.';
            } elseif ($action === 'return') {
                $borrowingModel->returnByBookCode($_SESSION['user']['id'], $bookCode, 'Website QR');
                $successMessage = 'Pengembalian via QR berhasil diproses.';
            } else {
                $scannedBook = $bookModel->getByCode($bookCode);
                if (!$scannedBook) {
                    throw new RuntimeException('Kode QR buku tidak ditemukan.');
                }
                $qrLogModel->createLog($_SESSION['user']['id'], $scannedBook['id'], 'verify', 'Website QR');
                $successMessage = 'Kode QR valid untuk buku "' . $scannedBook['title'] . '".';
            }

            $scannedBook = $bookModel->getByCode($bookCode);
        } catch (\Throwable $e) {
            $errorMessage = $e->getMessage();
        }
    }
}

$pageTitle = 'Scan QR - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
?>
<main class="page-shell">
    <section class="page-title">
        <span class="eyebrow">QR backend</span>
        <h1>Validasi QR Code Buku</h1>
        <p>Masukkan kode QR buku untuk validasi, peminjaman, atau pengembalian yang langsung tersimpan ke database.</p>
    </section>

    <?php if ($successMessage): ?>
        <div class="alert alert-success" style="background:#d4edda;color:#155724;padding:1rem;border-radius:8px;margin-bottom:1rem;">
            <?= e($successMessage); ?>
        </div>
    <?php endif; ?>
    <?php if ($errorMessage): ?>
        <div class="alert alert-danger" style="background:#f8d7da;color:#721c24;padding:1rem;border-radius:8px;margin-bottom:1rem;">
            <?= e($errorMessage); ?>
        </div>
    <?php endif; ?>

    <section class="scan-layout">
        <article class="scan-panel">
            <h2>Proses kode QR</h2>
            <form class="form-stack" method="post" action="<?= page_url('scan-qr.php'); ?>">
                <label>
                    <span>Kode Buku / QR</span>
                    <input type="text" name="book_code" value="<?= e($bookCode); ?>" placeholder="TECH001" required>
                </label>
                <label>
                    <span>Aksi</span>
                    <select name="action">
                        <option value="verify" <?= $action === 'verify' ? 'selected' : ''; ?>>Validasi</option>
                        <option value="borrow" <?= $action === 'borrow' ? 'selected' : ''; ?>>Pinjam via QR</option>
                        <option value="return" <?= $action === 'return' ? 'selected' : ''; ?>>Kembalikan via QR</option>
                    </select>
                </label>
                <button class="btn btn-primary" type="submit">Proses QR</button>
            </form>
        </article>

        <article class="scan-panel">
            <h2>Hasil validasi</h2>
            <?php if ($scannedBook): ?>
                <span class="status-pill <?= status_class($scannedBook['available_stock'] > 0 ? 'Tersedia' : 'Dipinjam'); ?>">
                    <?= e($scannedBook['available_stock'] > 0 ? 'Tersedia' : 'Dipinjam'); ?>
                </span>
                <h3><?= e($scannedBook['title']); ?></h3>
                <p>Penulis: <?= e($scannedBook['author']); ?></p>
                <p>Kategori: <?= e($scannedBook['category_name'] ?? '-'); ?></p>
                <p>Stok: <?= e((string) $scannedBook['available_stock']); ?>/<?= e((string) $scannedBook['stock']); ?></p>
                <a class="text-link" href="<?= page_url('book-detail.php?id=' . $scannedBook['id']); ?>">Lihat detail buku</a>
            <?php else: ?>
                <p>Belum ada kode QR yang diproses.</p>
            <?php endif; ?>
        </article>
    </section>
</main>
<?php
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';
