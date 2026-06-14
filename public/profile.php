<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is logged in
requireLogin();

// Load user data from database
use App\Models\User;

$userModel = new User();
$user = $userModel->getUserWithStats($_SESSION['user']['id']);

$pageTitle = 'Profil - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
require_once __DIR__ . '/../app/views/pages/profile-content.php';
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';

