const navToggle = document.querySelector('[data-nav-toggle]');
const navMenu = document.querySelector('[data-nav-menu]');
const adminToggle = document.querySelector('[data-admin-toggle]');
const adminSidebar = document.querySelector('[data-admin-sidebar]');

if (navToggle && navMenu) {
  navToggle.addEventListener('click', () => {
    const expanded = navToggle.getAttribute('aria-expanded') === 'true';
    navToggle.setAttribute('aria-expanded', String(!expanded));
    navMenu.classList.toggle('is-open');
  });
}

if (adminToggle && adminSidebar) {
  adminToggle.addEventListener('click', () => {
    adminSidebar.classList.toggle('is-open');
  });
}

const searchInput = document.querySelector('[data-catalog-search]');
const categoryFilter = document.querySelector('[data-category-filter]');
const bookCards = Array.from(document.querySelectorAll('[data-book-card]'));
const emptyState = document.querySelector('[data-empty-state]');

function filterCatalog() {
  const keyword = (searchInput?.value || '').trim().toLowerCase();
  const category = categoryFilter?.value || 'all';
  let visibleCount = 0;

  bookCards.forEach((card) => {
    const textMatch = card.dataset.title.includes(keyword) || card.dataset.author.includes(keyword);
    const categoryMatch = category === 'all' || card.dataset.category === category;
    const isVisible = textMatch && categoryMatch;

    card.hidden = !isVisible;
    if (isVisible) visibleCount += 1;
  });

  if (emptyState) {
    emptyState.hidden = visibleCount !== 0;
  }
}

if (searchInput && categoryFilter) {
  searchInput.addEventListener('input', filterCatalog);
  categoryFilter.addEventListener('change', filterCatalog);
}

const startScanButton = document.querySelector('[data-start-scan]');
const scanResult = document.querySelector('[data-scan-result]');
const scanLine = document.querySelector('[data-scan-line]');

if (startScanButton && scanResult) {
  startScanButton.addEventListener('click', () => {
    startScanButton.disabled = true;
    startScanButton.textContent = 'Memindai...';
    scanLine?.classList.add('is-scanning');

    window.setTimeout(() => {
      scanResult.hidden = false;
      startScanButton.disabled = false;
      startScanButton.textContent = 'Scan Ulang';
      scanLine?.classList.remove('is-scanning');
    }, 900);
  });
}
