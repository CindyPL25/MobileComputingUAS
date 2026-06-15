<?php 
$isLoggedIn = isset($_SESSION['user']);
$userRole = $isLoggedIn ? $_SESSION['user']['role'] : null;
?>
<nav class="bottom-nav" aria-label="Navigasi mobile">
    <a class="<?= active_class('index.php'); ?>" href="<?= page_url('index.php'); ?>">
        <span class="nav-icon">H</span>
        <span>Home</span>
    </a>
    <a class="<?= active_class('catalog.php'); ?>" href="<?= page_url('catalog.php'); ?>">
        <span class="nav-icon">K</span>
        <span>Katalog</span>
    </a>
    
    <?php if ($isLoggedIn): ?>
        <a class="scan <?= active_class('scan-qr.php'); ?>" href="<?= page_url('scan-qr.php'); ?>">
            <span class="nav-icon">QR</span>
            <span>Scan</span>
        </a>

        <?php if ($userRole === 'mahasiswa'): ?>
            <a class="<?= active_class('borrow-history.php'); ?>" href="<?= page_url('borrow-history.php'); ?>">
                <span class="nav-icon">R</span>
                <span>Riwayat</span>
            </a>
            <a class="<?= active_class('notifications.php'); ?>" href="<?= page_url('notifications.php'); ?>">
                <span class="nav-icon">N</span>
                <span>Notif</span>
            </a>
            <a class="<?= active_class('profile.php'); ?>" href="<?= page_url('profile.php'); ?>">
                <span class="nav-icon">P</span>
                <span>Profil</span>
            </a>
        <?php endif; ?>

        <?php if ($userRole === 'admin'): ?>
            <a class="<?= active_class('admin-dashboard.php'); ?>" href="<?= page_url('admin-dashboard.php'); ?>">
                <span class="nav-icon">A</span>
                <span>Admin</span>
            </a>
        <?php endif; ?>

    <?php else: ?>
        <a class="<?= active_class('login.php'); ?>" href="<?= page_url('login.php'); ?>">
            <span class="nav-icon">L</span>
            <span>Login</span>
        </a>
    <?php endif; ?>
</nav>

