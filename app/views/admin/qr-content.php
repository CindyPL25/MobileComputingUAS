<section class="admin-page-title">
    <div>
        <span class="eyebrow">QR Code</span>
        <h1>Log scan dan kode QR buku</h1>
        <p>Pantau scan QR terbaru dan kode unik buku yang tersimpan di database.</p>
    </div>
</section>

<section class="admin-two-column">
    <article class="admin-panel">
        <div class="admin-panel-heading">
            <h2>Kode QR koleksi</h2>
            <span><?= count($books); ?> buku</span>
        </div>
        <style>
        .qr-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }
        .qr-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .qr-canvas-container {
            margin-bottom: 1rem;
            padding: 10px;
            background: #fff;
            border: 1px solid #edf2f7;
            border-radius: 4px;
        }
        .qr-canvas-container img, .qr-canvas-container canvas {
            display: block;
            margin: 0 auto;
        }
        .qr-info h3 {
            font-size: 1rem;
            margin: 0 0 0.25rem 0;
            color: #2d3748;
            line-height: 1.3;
        }
        .qr-info p {
            font-size: 0.85rem;
            margin: 0;
            color: #718096;
        }
        .qr-code-text {
            font-family: monospace;
            font-size: 1.1rem;
            font-weight: 600;
            color: #3182ce;
            margin: 0.5rem 0;
        }
        .qr-actions {
            display: flex;
            gap: 0.5rem;
            width: 100%;
            margin-top: auto;
            padding-top: 1rem;
        }
        .qr-btn {
            flex: 1;
            padding: 0.5rem;
            font-size: 0.8rem;
            border-radius: 4px;
            cursor: pointer;
            border: 1px solid #e2e8f0;
            background: #f8fafc;
            color: #4a5568;
            transition: all 0.2s;
        }
        .qr-btn:hover {
            background: #e2e8f0;
        }
        .qr-btn-primary {
            background: #3182ce;
            color: white;
            border-color: #3182ce;
        }
        .qr-btn-primary:hover {
            background: #2b6cb0;
        }
        </style>

        <div class="qr-grid">
            <?php foreach ($books as $index => $book): ?>
                <div class="qr-card">
                    <div class="qr-canvas-container" id="qr-container-<?= $index; ?>" data-code="<?= e($book['book_code']); ?>"></div>
                    
                    <div class="qr-info">
                        <h3><?= e($book['title']); ?></h3>
                        <p><?= e($book['category_name'] ?? '-'); ?> - Stok <?= e((string) $book['available_stock']); ?>/<?= e((string) $book['stock']); ?></p>
                        <div class="qr-code-text"><?= e($book['book_code']); ?></div>
                    </div>
                    
                    <div class="qr-actions">
                        <button type="button" class="qr-btn" onclick="downloadQR('qr-container-<?= $index; ?>', '<?= e($book['book_code']); ?>')">Download</button>
                        <button type="button" class="qr-btn qr-btn-primary" onclick="printQR('qr-container-<?= $index; ?>', '<?= e(addslashes($book['title'])); ?>', '<?= e($book['book_code']); ?>')">Cetak</button>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </article>

    <article class="admin-panel">
        <div class="admin-panel-heading">
            <h2>Riwayat scan</h2>
            <span><?= count($qrScans); ?> log</span>
        </div>
        <div class="admin-list">
            <?php foreach ($qrScans as $scan): ?>
                <div class="admin-list-item">
                    <div>
                        <strong><?= e($scan['book_title']); ?></strong>
                        <span><?= e($scan['user_name']); ?> - <?= e($scan['location'] ?? '-'); ?></span>
                        <span><?= e(date('d M Y H:i', strtotime($scan['created_at']))); ?></span>
                    </div>
                    <em><?= e($scan['scan_type']); ?></em>
                </div>
            <?php endforeach; ?>
            <?php if (empty($qrScans)): ?>
                <p class="empty-state">Belum ada log scan QR.</p>
            <?php endif; ?>
        </div>
    </article>
</section>

<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    // Generate all QR codes dynamically based on data-code attributes
    const qrContainers = document.querySelectorAll('.qr-canvas-container');
    qrContainers.forEach(container => {
        const bookCode = container.getAttribute('data-code');
        new QRCode(container, {
            text: bookCode, // STRICTLY PLAIN TEXT identifier for Flutter
            width: 150,
            height: 150,
            colorDark : "#000000",
            colorLight : "#ffffff",
            correctLevel : QRCode.CorrectLevel.H
        });
    });
});

function downloadQR(containerId, bookCode) {
    const container = document.getElementById(containerId);
    const img = container.querySelector('img');
    const canvas = container.querySelector('canvas');
    let url = '';
    
    if (img && img.src && img.src.startsWith('data:image')) {
        url = img.src;
    } else if (canvas) {
        url = canvas.toDataURL("image/png");
    } else {
        alert("QR Code belum siap untuk diunduh.");
        return;
    }
    
    const a = document.createElement("a");
    a.href = url;
    a.download = "QR_" + bookCode + ".png";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
}

function printQR(containerId, bookTitle, bookCode) {
    const container = document.getElementById(containerId);
    const img = container.querySelector('img');
    const canvas = container.querySelector('canvas');
    let url = '';
    
    if (img && img.src && img.src.startsWith('data:image')) {
        url = img.src;
    } else if (canvas) {
        url = canvas.toDataURL("image/png");
    }
    
    if (!url) {
        alert("QR Code belum siap dicetak.");
        return;
    }

    const printWin = window.open('', '', 'width=600,height=600');
    printWin.document.write(`
        <html>
            <head>
                <title>Cetak QR - ${bookCode}</title>
                <style>
                    body { font-family: sans-serif; text-align: center; padding: 50px; }
                    .qr-wrapper { display: inline-block; padding: 20px; border: 2px dashed #ccc; }
                    img { width: 250px; height: 250px; }
                    h2 { margin: 10px 0 5px 0; font-size: 20px; }
                    p { margin: 0; font-size: 24px; font-weight: bold; font-family: monospace; }
                </style>
            </head>
            <body>
                <div class="qr-wrapper">
                    <h2>${bookTitle}</h2>
                    <img src="${url}" />
                    <p>${bookCode}</p>
                </div>
                <script>
                    setTimeout(() => {
                        window.print();
                        window.close();
                    }, 500);
                <\/script>
            </body>
        </html>
    `);
    printWin.document.close();
}
</script>
