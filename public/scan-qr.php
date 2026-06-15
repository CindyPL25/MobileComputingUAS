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
            
            <!-- Area Kamera -->
            <div id="qr-reader-container" style="display:none; margin-bottom: 1rem; border-radius: 8px; overflow: hidden; border: 2px solid #e2e8f0;">
                <div id="qr-reader" style="width: 100%;"></div>
            </div>
            
            <div style="display: flex; gap: 0.5rem; margin-bottom: 1.5rem;">
                <button type="button" id="btn-start-scan" class="btn btn-primary" style="flex: 1; padding: 0.6rem; font-size: 0.9rem; border-radius: 6px; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/></svg>
                    Buka Kamera
                </button>
                <button type="button" id="btn-stop-scan" style="display:none; flex: 1; padding: 0.6rem; font-size: 0.9rem; background-color: #e53e3e; border: 1px solid #e53e3e; color: white; border-radius: 6px; align-items: center; justify-content: center; gap: 0.5rem; cursor: pointer;">
                    Tutup Kamera
                </button>
            </div>
            
            <div id="scan-feedback" style="display:none; margin-bottom: 1rem; padding: 0.75rem; border-radius: 6px; font-size: 0.9rem; font-weight: 500;"></div>

            <form class="form-stack" id="qr-form" method="post" action="<?= page_url('scan-qr.php'); ?>">
                <label>
                    <span>Kode Buku / QR</span>
                    <input type="text" id="book_code_input" name="book_code" value="<?= e($bookCode); ?>" placeholder="TECH001" required>
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

    <!-- Script HTML5 QR Code -->
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    <script>
    document.addEventListener("DOMContentLoaded", function() {
        const btnStart = document.getElementById('btn-start-scan');
        const btnStop = document.getElementById('btn-stop-scan');
        const readerContainer = document.getElementById('qr-reader-container');
        const bookCodeInput = document.getElementById('book_code_input');
        const feedback = document.getElementById('scan-feedback');
        
        let html5QrCode;

        function showFeedback(msg, isSuccess) {
            feedback.style.display = 'block';
            feedback.style.backgroundColor = isSuccess ? '#d4edda' : '#f8d7da';
            feedback.style.color = isSuccess ? '#155724' : '#721c24';
            feedback.innerHTML = msg;
            
            setTimeout(() => {
                feedback.style.display = 'none';
            }, 5000);
        }

        btnStart.addEventListener('click', function() {
            if (!html5QrCode) {
                html5QrCode = new Html5Qrcode("qr-reader");
            }
            
            readerContainer.style.display = 'block';
            btnStart.style.display = 'none';
            btnStop.style.display = 'flex';
            
            html5QrCode.start(
                { facingMode: "environment" }, // Prefer back camera
                {
                    fps: 10,
                    qrbox: { width: 250, height: 250 }
                },
                (decodedText, decodedResult) => {
                    // Success callback
                    bookCodeInput.value = decodedText;
                    
                    // Visual feedback
                    showFeedback('&#10003; Berhasil membaca QR! Teks dimasukkan otomatis.', true);
                    
                    // Stop camera after successful read
                    stopScanner();
                },
                (errorMessage) => {
                    // Ignore parse errors as they are frequent while positioning
                }
            ).catch((err) => {
                // Startup error (e.g., no camera permission)
                stopScanner();
                showFeedback('Gagal mengakses kamera. Silakan ketik manual. Detail: ' + err, false);
            });
        });
        
        btnStop.addEventListener('click', function() {
            stopScanner();
        });
        
        function stopScanner() {
            if (html5QrCode && html5QrCode.isScanning) {
                html5QrCode.stop().then((ignore) => {
                    readerContainer.style.display = 'none';
                    btnStart.style.display = 'flex';
                    btnStop.style.display = 'none';
                }).catch((err) => {
                    console.error("Gagal mematikan scanner.", err);
                });
            } else {
                readerContainer.style.display = 'none';
                btnStart.style.display = 'flex';
                btnStop.style.display = 'none';
            }
        }
    });
    </script>
</main>
<?php
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';
