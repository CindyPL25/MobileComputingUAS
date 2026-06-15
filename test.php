<?php
$pdo = new PDO('mysql:host=127.0.0.1;dbname=elibrary_mobile', 'root', '');
$stmt = $pdo->query('SELECT nim, email, role FROM users');
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));
?>
