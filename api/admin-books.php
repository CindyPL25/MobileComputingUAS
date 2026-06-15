<?php
require_once __DIR__ . '/base.php';

use App\Models\Book;

api_guard(function() {
    $user = require_auth();
    if ($user['role'] !== 'admin') {
        send_json(false, "Forbidden. Admin access required.", null, 403);
    }

    $bookModel = new Book();
    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === 'GET') {
        $books = $bookModel->getAllWithCategory();
        send_json(true, "Books retrieved successfully", $books);
    } 
    elseif ($method === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true) ?? [];
        
        $stock = max(0, (int) ($input['stock'] ?? 0));
        $bookCode = trim($input['book_code'] ?? '');
        if ($bookCode === '') {
            $bookCode = 'BK-' . date('YmdHis');
        }

        $data = [
            'title' => trim($input['title'] ?? ''),
            'author' => trim($input['author'] ?? ''),
            'publisher' => trim($input['publisher'] ?? ''),
            'publication_year' => ($input['publication_year'] ?? '') !== '' ? (int) $input['publication_year'] : null,
            'isbn' => trim($input['isbn'] ?? ''),
            'category_id' => (int) ($input['category_id'] ?? 0),
            'description' => trim($input['description'] ?? ''),
            'cover_image' => trim($input['cover_image'] ?? ''), // Bypass image upload, use existing or empty
            'stock' => $stock,
            'available_stock' => $stock,
            'book_code' => $bookCode
        ];
        
        try {
            $id = $bookModel->insert($data);
            $data['id'] = $id;
            send_json(true, "Buku berhasil ditambahkan.", $data);
        } catch (\Exception $e) {
            send_json(false, "Gagal menambah buku: " . $e->getMessage(), null, 500);
        }
    } 
    elseif ($method === 'PUT') {
        $input = json_decode(file_get_contents('php://input'), true) ?? [];
        $id = (int) ($input['id'] ?? 0);
        
        try {
            $currentBook = $bookModel->getById($id);
            if (!$currentBook) {
                send_json(false, "Buku tidak ditemukan.", null, 404);
                return;
            }

            $stock = max(0, (int) ($input['stock'] ?? 0));
            $borrowedCopies = $bookModel->countActiveBorrowedCopies($id);
            if ($stock < $borrowedCopies) {
                send_json(false, "Stok tidak boleh lebih kecil dari jumlah buku yang sedang dipinjam.", null, 400);
                return;
            }

            $data = [
                'title' => trim($input['title'] ?? ''),
                'author' => trim($input['author'] ?? ''),
                'publisher' => trim($input['publisher'] ?? ''),
                'publication_year' => ($input['publication_year'] ?? '') !== '' ? (int) $input['publication_year'] : null,
                'isbn' => trim($input['isbn'] ?? ''),
                'category_id' => (int) ($input['category_id'] ?? 0),
                'description' => trim($input['description'] ?? ''),
                'book_code' => trim($input['book_code'] ?? $currentBook['book_code']),
                'stock' => $stock,
                'available_stock' => $stock - $borrowedCopies
            ];
            
            if (isset($input['cover_image'])) {
                $data['cover_image'] = trim($input['cover_image']);
            }

            $bookModel->update($id, $data);
            send_json(true, "Buku berhasil diperbarui.", $data);
        } catch (\Exception $e) {
            send_json(false, "Gagal memperbarui buku: " . $e->getMessage(), null, 500);
        }
    } 
    elseif ($method === 'DELETE') {
        $input = json_decode(file_get_contents('php://input'), true) ?? [];
        $id = (int) ($input['id'] ?? 0);
        try {
            $bookModel->delete($id);
            send_json(true, "Buku berhasil dihapus.", null);
        } catch (\Exception $e) {
            send_json(false, "Gagal menghapus buku (mungkin sedang dipinjam).", null, 500);
        }
    } 
    else {
        send_json(false, "Method not allowed", null, 405);
    }
});
?>
