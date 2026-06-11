<main class="page-shell">
    <section class="page-title">
        <span class="eyebrow">Katalog digital</span>
        <h1>Temukan buku kampus</h1>
        <p>Cari koleksi berdasarkan judul, penulis, atau kategori. Data masih dummy dan siap dihubungkan ke database.</p>
    </section>

    <?php include __DIR__ . '/../components/search-bar.php'; ?>

    <section class="book-grid catalog-grid" data-catalog-grid>
        <?php foreach ($books as $book): ?>
            <?php include __DIR__ . '/../components/book-card.php'; ?>
        <?php endforeach; ?>
    </section>

    <p class="empty-state" data-empty-state hidden>Tidak ada buku yang cocok dengan pencarian.</p>
</main>

