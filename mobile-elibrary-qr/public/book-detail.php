<?php
require_once __DIR__ . '/../app/helpers/functions.php';
require_once __DIR__ . '/../app/data/books.php';
$bookId = isset($_GET['id']) ? (int) $_GET['id'] : 1;
$book = find_book_by_id($books, $bookId) ?? $books[0];
$pageTitle = $book['title'] . ' - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
?>
<main class="page-shell">
    <section class="detail-layout">
        <div class="detail-cover">
            <img src="<?= media_url($book['cover']); ?>" alt="Cover <?= e($book['title']); ?>">
        </div>
        <article class="detail-content">
            <span class="category-pill"><?= e($book['category']); ?></span>
            <h1><?= e($book['title']); ?></h1>
            <p class="lead"><?= e($book['description']); ?></p>
            <dl class="detail-list">
                <div>
                    <dt>Penulis</dt>
                    <dd><?= e($book['author']); ?></dd>
                </div>
                <div>
                    <dt>Tahun</dt>
                    <dd><?= e($book['year']); ?></dd>
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
            <div class="detail-actions">
                <a class="btn btn-primary" href="#">Pinjam Buku</a>
                <a class="btn btn-light" href="<?= page_url('catalog.php'); ?>">Kembali ke Katalog</a>
            </div>
        </article>
    </section>
</main>
<?php
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';
