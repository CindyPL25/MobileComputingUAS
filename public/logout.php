<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Destroy session
session_destroy();

header('Location: ' . page_url('login.php'));
exit;

