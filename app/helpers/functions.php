<?php

function e($value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}

function asset_url(string $path): string
{
    return '../assets/' . ltrim($path, '/');
}

function media_url($path): string
{
    $path = (string) ($path ?: 'images/logo.png');

    if (preg_match('/^https?:\/\//', $path)) {
        return $path;
    }

    return asset_url($path);
}

function page_url(string $path): string
{
    return $path;
}

function current_page(): string
{
    return basename($_SERVER['SCRIPT_NAME'] ?? 'index.php');
}

function active_class(string $page): string
{
    return current_page() === $page ? 'is-active' : '';
}

function status_class(string $status): string
{
    return strtolower($status) === 'tersedia' ? 'status-available' : 'status-borrowed';
}

function find_book_by_id(array $books, int $id): ?array
{
    foreach ($books as $book) {
        if ((int) $book['id'] === $id) {
            return $book;
        }
    }

    return null;
}

function book_categories(array $books): array
{
    $categories = array_map(fn ($book) => $book['category'], $books);
    $categories = array_values(array_unique($categories));
    sort($categories);

    return $categories;
}
