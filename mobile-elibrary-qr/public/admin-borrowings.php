<?php
require_once __DIR__ . '/../app/helpers/functions.php';
require_once __DIR__ . '/../app/data/history.php';
$pageTitle = 'Peminjaman Admin - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'Peminjaman';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php require_once __DIR__ . '/../app/views/admin/borrowings-content.php'; ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

