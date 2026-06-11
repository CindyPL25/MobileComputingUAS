<?php
$pageTitle = $pageTitle ?? 'Mobile E-Library Kampus';
$bodyClass = $bodyClass ?? '';
?>
<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($pageTitle); ?></title>
    <link rel="stylesheet" href="<?= asset_url('css/style.css'); ?>">
</head>
<body class="<?= e($bodyClass); ?>">

