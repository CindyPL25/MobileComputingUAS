<?php
require_once __DIR__ . '/base.php';

use App\Models\Book;
use App\Models\Category;

api_guard(function() {
    if (!in_array($_SERVER['REQUEST_METHOD'], ['GET', 'POST'], true)) {
        send_json(false, "Method not allowed", null, 405);
    }

    $bookModel = new Book();

    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        // Public access allowed for books list

        $books = $bookModel->getRecentWithCategory(100);
        send_json(true, "Books retrieved successfully", $books);
    }

    $user = require_auth();
    if (($user['role'] ?? '') !== 'admin') {
        send_json(false, "Forbidden. Admin role required.", null, 403);
    }

    $input = json_decode(file_get_contents('php://input'), true);
    if (!is_array($input)) {
        $input = $_POST;
    }

    $title = trim($input['title'] ?? '');
    $author = trim($input['author'] ?? '');
    $categoryName = trim($input['category'] ?? '');
    $categoryId = (int) ($input['category_id'] ?? 0);
    $stock = max(0, (int) ($input['stock'] ?? 1));

    if ($title === '' || $author === '') {
        send_json(false, "Judul dan penulis wajib diisi.", null, 422);
    }

    $categoryModel = new Category();
    if ($categoryId <= 0) {
        if ($categoryName === '') {
            $categoryName = 'Umum';
        }

        $category = $categoryModel->findBy('name', $categoryName);
        if (!$category) {
            $categoryId = (int) $categoryModel->insert([
                'name' => $categoryName,
                'description' => 'Kategori dari Flutter admin',
            ]);
        } else {
            $categoryId = (int) $category['id'];
        }
    }

    $bookCode = trim($input['book_code'] ?? '');
    if ($bookCode === '') {
        $bookCode = 'BK-' . date('YmdHis');
    }

    if ($bookModel->getByCode($bookCode)) {
        send_json(false, "Kode buku sudah digunakan.", null, 422);
    }

    $bookId = $bookModel->insert([
        'title' => $title,
        'author' => $author,
        'publisher' => trim($input['publisher'] ?? ''),
        'publication_year' => ($input['publication_year'] ?? '') !== '' ? (int) $input['publication_year'] : null,
        'isbn' => trim($input['isbn'] ?? ''),
        'category_id' => $categoryId,
        'description' => trim($input['description'] ?? ''),
        'cover_image' => trim($input['cover_image'] ?? ''),
        'stock' => $stock,
        'available_stock' => $stock,
        'book_code' => $bookCode,
        'is_popular' => !empty($input['is_popular']) ? 1 : 0,
    ]);

    $createdBook = $bookModel->getBookDetail($bookId);
    send_json(true, "Buku berhasil ditambahkan.", $createdBook, 201);
});
?>
