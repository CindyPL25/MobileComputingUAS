<aside class="admin-sidebar" data-admin-sidebar>
    <a class="admin-brand" href="<?= page_url('admin-dashboard.php'); ?>">
        <img src="<?= asset_url('images/logo.png'); ?>" alt="Logo E-Library">
        <span>Admin E-Library</span>
    </a>

    <div class="admin-sidebar-card">
        <span>Hari ini</span>
        <strong>18 Scan QR</strong>
        <p>3 peminjaman sedang diproses</p>
    </div>

    <nav class="admin-menu" aria-label="Menu admin">
        <a class="<?= active_class('admin-dashboard.php'); ?>" href="<?= page_url('admin-dashboard.php'); ?>"><span>DB</span>Dashboard</a>
        <a class="<?= active_class('admin-books.php'); ?>" href="<?= page_url('admin-books.php'); ?>"><span>BK</span>Data Buku</a>
        <a class="<?= active_class('admin-borrowings.php'); ?>" href="<?= page_url('admin-borrowings.php'); ?>"><span>PM</span>Peminjaman</a>
        <a class="<?= active_class('admin-users.php'); ?>" href="<?= page_url('admin-users.php'); ?>"><span>MH</span>Mahasiswa</a>
        <a class="<?= active_class('admin-qr.php'); ?>" href="<?= page_url('admin-qr.php'); ?>"><span>QR</span>QR Scan</a>
        <a class="<?= active_class('admin-profile.php'); ?>" href="<?= page_url('admin-profile.php'); ?>"><span>AD</span>Profil Admin</a>
    </nav>

    <a class="admin-exit" href="<?= page_url('index.php'); ?>">Lihat Website</a>
</aside>
