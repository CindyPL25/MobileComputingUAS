<?php
require_once __DIR__ . '/../app/helpers/functions.php';
require_once __DIR__ . '/../app/data/books.php';
require_once __DIR__ . '/../app/data/history.php';
require_once __DIR__ . '/../app/data/users.php';
require_once __DIR__ . '/../app/data/qr-scans.php';
$pageTitle = 'Dashboard Admin - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'Dashboard Admin';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php require_once __DIR__ . '/../app/views/admin/dashboard-content.php'; ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

