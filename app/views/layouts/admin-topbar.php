<header class="admin-topbar">
    <button class="admin-toggle" type="button" data-admin-toggle aria-label="Buka menu admin">Menu</button>
    <div>
        <strong><?= e($adminTitle ?? 'Dashboard Admin'); ?></strong>
        <span>Frontend panel pengelola perpustakaan</span>
    </div>
    <label class="admin-search" for="adminSearch">
        <span>Cari</span>
        <input id="adminSearch" type="search" placeholder="Cari buku, mahasiswa, QR">
    </label>
    <a href="<?= page_url('logout.php'); ?>" class="admin-user-pill logout-link" title="Logout">Logout</a>
</header>
