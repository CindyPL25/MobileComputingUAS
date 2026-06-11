<?php
require_once __DIR__ . '/../app/helpers/functions.php';
require_once __DIR__ . '/../app/data/books.php';
$categories = book_categories($books);
$pageTitle = 'Katalog Buku - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
require_once __DIR__ . '/../app/views/pages/catalog-content.php';
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';

