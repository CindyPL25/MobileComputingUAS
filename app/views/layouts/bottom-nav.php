<nav class="bottom-nav" aria-label="Navigasi mobile">
    <a class="<?= active_class('index.php'); ?>" href="<?= page_url('index.php'); ?>">
        <span class="nav-icon">H</span>
        <span>Home</span>
    </a>
    <a class="<?= active_class('catalog.php'); ?>" href="<?= page_url('catalog.php'); ?>">
        <span class="nav-icon">K</span>
        <span>Katalog</span>
    </a>
    <a class="scan <?= active_class('scan-qr.php'); ?>" href="<?= page_url('scan-qr.php'); ?>">
        <span class="nav-icon">QR</span>
        <span>Scan QR</span>
    </a>
    <a class="<?= active_class('borrow-history.php'); ?>" href="<?= page_url('borrow-history.php'); ?>">
        <span class="nav-icon">R</span>
        <span>Riwayat</span>
    </a>
    <a class="<?= active_class('profile.php'); ?>" href="<?= page_url('profile.php'); ?>">
        <span class="nav-icon">P</span>
        <span>Profil</span>
    </a>
</nav>

