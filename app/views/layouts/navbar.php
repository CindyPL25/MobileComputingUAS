<header class="topbar">
    <a class="brand" href="<?= page_url('index.php'); ?>" aria-label="Mobile E-Library Kampus">
        <img src="<?= asset_url('images/logo.png'); ?>" alt="Logo E-Library">
        <span>Mobile E-Library</span>
    </a>

    <button class="nav-toggle" type="button" aria-label="Buka menu" aria-expanded="false" data-nav-toggle>
        <span></span>
        <span></span>
        <span></span>
    </button>

    <?php 
    $isLoggedIn = isset($_SESSION['user']);
    $userRole = $isLoggedIn ? $_SESSION['user']['role'] : null;
    ?>

    <nav class="desktop-nav" data-nav-menu>
        <a class="<?= active_class('index.php'); ?>" href="<?= page_url('index.php'); ?>">Home</a>
        <a class="<?= active_class('catalog.php'); ?>" href="<?= page_url('catalog.php'); ?>">Katalog</a>
        
        <?php if ($isLoggedIn): ?>
            <a class="<?= active_class('scan-qr.php'); ?>" href="<?= page_url('scan-qr.php'); ?>">Scan QR</a>
            
            <?php if ($userRole === 'mahasiswa'): ?>
                <a class="<?= active_class('borrow-history.php'); ?>" href="<?= page_url('borrow-history.php'); ?>">Riwayat</a>
                <a class="<?= active_class('profile.php'); ?>" href="<?= page_url('profile.php'); ?>">Profil</a>
            <?php endif; ?>

            <?php if ($userRole === 'admin'): ?>
                <a class="<?= active_class('admin-dashboard.php'); ?>" href="<?= page_url('admin-dashboard.php'); ?>">Admin</a>
            <?php endif; ?>
        <?php endif; ?>
    </nav>

    <div class="nav-user-actions">
      <?php if ($isLoggedIn): ?>
          <a class="<?= active_class('notifications.php'); ?>" href="<?= page_url('notifications.php'); ?>" style="margin-right: 15px; position: relative;">Notifikasi</a>
          <a class="nav-logout" href="<?= page_url('logout.php'); ?>">Logout</a>
      <?php else: ?>
          <a class="nav-logout" href="<?= page_url('login.php'); ?>">Login</a>
      <?php endif; ?>
    </div>
</header>
