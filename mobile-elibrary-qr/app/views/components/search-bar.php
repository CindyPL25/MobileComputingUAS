<div class="catalog-tools">
    <label class="search-field" for="catalogSearch">
        <span>Cari</span>
        <input id="catalogSearch" type="search" placeholder="Judul buku atau penulis" data-catalog-search>
    </label>
    <label class="filter-field" for="categoryFilter">
        <span>Kategori</span>
        <select id="categoryFilter" data-category-filter>
            <option value="all">Semua kategori</option>
            <?php foreach ($categories as $category): ?>
                <option value="<?= e($category); ?>"><?= e($category); ?></option>
            <?php endforeach; ?>
        </select>
    </label>
</div>

