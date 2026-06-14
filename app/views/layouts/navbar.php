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

    <nav class="desktop-nav" data-nav-menu>
        <a class="<?= active_class('index.php'); ?>" href="<?= page_url('index.php'); ?>">Home</a>
        <a class="<?= active_class('catalog.php'); ?>" href="<?= page_url('catalog.php'); ?>">Katalog</a>
        <a class="<?= active_class('scan-qr.php'); ?>" href="<?= page_url('scan-qr.php'); ?>">Scan QR</a>
        <a class="<?= active_class('borrow-history.php'); ?>" href="<?= page_url('borrow-history.php'); ?>">Riwayat</a>
        <a class="<?= active_class('profile.php'); ?>" href="<?= page_url('profile.php'); ?>">Profil</a>
        <a class="<?= active_class('admin-dashboard.php'); ?>" href="<?= page_url('admin-login.php'); ?>">Admin</a>
    </nav>

    <div class="nav-user-actions">
      <a class="nav-logout" href="<?= page_url('logout.php'); ?>">Logout</a>
    </div>
</header>
