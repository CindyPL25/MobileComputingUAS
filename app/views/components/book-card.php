<article class="book-card" data-book-card data-title="<?= e(strtolower($book['title'])); ?>" data-author="<?= e(strtolower($book['author'])); ?>" data-category="<?= e($book['category_name'] ?? $book['category'] ?? '-'); ?>">
    <div class="book-cover">
        <img src="<?= media_url($book['cover_image'] ?: 'images/logo.png'); ?>" alt="Cover <?= e($book['title']); ?>" loading="lazy">
    </div>
    <div class="book-info">
        <span class="category-pill"><?= e($book['category_name'] ?? $book['category'] ?? '-'); ?></span>
        <h3><?= e($book['title']); ?></h3>
        <p><?= e($book['author'] ?? '-'); ?></p>
        <p class="publisher-line"><?= e($book['publisher'] ?? '-'); ?> · <?= e($book['publication_year'] ?? '-'); ?></p>
        <div class="book-meta">
            <span class="status-pill <?= status_class($book['available_stock'] > 0 ? 'Tersedia' : 'Dipinjam'); ?>"><?= e($book['available_stock'] > 0 ? 'Tersedia' : 'Dipinjam'); ?></span>
            <a class="text-link" href="<?= page_url('book-detail.php?id=' . $book['id']); ?>">Detail</a>
        </div>
    </div>
</article>
