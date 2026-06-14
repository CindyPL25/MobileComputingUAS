<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Load book detail from database
use App\Models\Book;

$bookModel = new Book();
$bookId = isset($_GET['id']) ? (int) $_GET['id'] : (isset($_POST['id']) ? (int) $_POST['id'] : 1);
$book = $bookModel->getBookDetail($bookId);

if (!$book) {
    header('Location: catalog.php');
    exit;
}

$successMessage = '';
$errorMessage = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'borrow') {
    if (!isset($_SESSION['user'])) {
        header('Location: login.php');
        exit;
    }
    
    if ($book['available_stock'] <= 0) {
        $errorMessage = "Maaf, stok buku ini sedang kosong.";
    } else {
        try {
            $db = \App\Config\Database::getInstance();
            $userId = $_SESSION['user']['id'];
            $borrowDate = date('Y-m-d');
            $dueDate = date('Y-m-d', strtotime('+7 days'));
            
            // Insert header
            $db->execute("INSERT INTO borrowings (user_id, borrow_date, due_date, status) VALUES (?, ?, ?, 'active')", [$userId, $borrowDate, $dueDate]);
            $borrowingId = $db->lastInsertId();
            
            // Insert detail (Trigger will automatically decrease available_stock!)
            $db->execute("INSERT INTO borrowing_details (borrowing_id, book_id) VALUES (?, ?)", [$borrowingId, $bookId]);
            
            $successMessage = "Buku berhasil dipinjam! Harap kembalikan sebelum " . date('d M Y', strtotime($dueDate));
            
            // Reload book data to reflect stock changes
            $book = $bookModel->getBookDetail($bookId);
        } catch (\Exception $e) {
            $errorMessage = "Terjadi kesalahan sistem: " . $e->getMessage();
        }
    }
}

// Determine book status based on availability
$book['status'] = $book['available_stock'] > 0 ? 'Tersedia' : 'Dipinjam';
$book['source_url'] = '#'; // Placeholder for source URL

$pageTitle = $book['title'] . ' - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
?>
<main class="page-shell">
    <section class="detail-layout">
        <div class="detail-cover">
            <img src="<?= media_url($book['cover_image']); ?>" alt="Cover <?= e($book['title']); ?>">
        </div>
        <article class="detail-content">
            <?php if (!empty($successMessage)): ?>
                <div class="alert alert-success" style="background: #d4edda; color: #155724; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                    <?= e($successMessage); ?>
                </div>
            <?php endif; ?>
            <?php if (!empty($errorMessage)): ?>
                <div class="alert alert-danger" style="background: #f8d7da; color: #721c24; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
                    <?= e($errorMessage); ?>
                </div>
            <?php endif; ?>
            
            <span class="category-pill">Book</span>
            <h1><?= e($book['title']); ?></h1>
            <p class="lead"><?= e($book['description']); ?></p>
            <dl class="detail-list">
                <div>
                    <dt>Penulis</dt>
                    <dd><?= e($book['author']); ?></dd>
                </div>
                <div>
                    <dt>Tahun</dt>
                    <dd><?= e($book['publication_year']); ?></dd>
                </div>
                <div>
                    <dt>Penerbit</dt>
                    <dd><?= e($book['publisher']); ?></dd>
                </div>
                <div>
                    <dt>ISBN</dt>
                    <dd><?= e($book['isbn']); ?></dd>
                </div>
                <div>
                    <dt>Status</dt>
                    <dd><span class="status-pill <?= status_class($book['status']); ?>"><?= e($book['status']); ?></span></dd>
                </div>
                <div>
                    <dt>Sumber Data</dt>
                    <dd><a class="text-link" href="<?= e($book['source_url']); ?>" target="_blank" rel="noopener">Lihat sumber</a></dd>
                </div>
            </dl>
            <?php include __DIR__ . '/../app/views/components/qr-placeholder.php'; ?>
            
            <div class="detail-actions" style="display:flex; gap:10px;">
                <?php if ($book['available_stock'] > 0): ?>
                    <form method="POST" action="">
                        <input type="hidden" name="action" value="borrow">
                        <input type="hidden" name="id" value="<?= $book['id'] ?>">
                        <button type="submit" class="btn btn-primary">Pinjam Buku</button>
                    </form>
                <?php else: ?>
                    <button class="btn btn-primary" disabled style="opacity:0.5; cursor:not-allowed;">Kosong</button>
                <?php endif; ?>
                <a class="btn btn-light" href="<?= page_url('catalog.php'); ?>">Kembali ke Katalog</a>
            </div>
        </article>
    </section>
</main>
<?php
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';
