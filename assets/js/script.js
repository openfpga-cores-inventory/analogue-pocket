(function () {
  // Search Input
  document.getElementById('input-search')?.addEventListener('change', function (e) {
    search();
  });

  // Search Button
  document.getElementById('button-search')?.addEventListener('click', function (e) {
    search();
  });

  // Sort Dropdown
  document.getElementById('dropdown-sort')?.addEventListener('change', function (e) {
    sort();
  });

  // Sort Button
  document.getElementById('button-sort')?.addEventListener('click', function (e) {
    const icon = this.querySelector('i');

    // Toggle sorting icon
    icon.classList.toggle('bi-sort-up');
    icon.classList.toggle('bi-sort-down');

    // Update sorting label
    const order = icon.classList.contains('bi-sort-down') ? 'Descending' : 'Ascending';
    icon.setAttribute('aria-label', order);

    sort();
  });

  // Category Filter
  document.querySelectorAll('input[name=filter-platform]').forEach(function (item) {
    item.addEventListener('change', function (e) {
      filter();
    });
  });

  const GRID_CORES_ID = 'grid-cores';

  const coreName = (card) => card.querySelector('.card-title')?.innerText;
  const coreAuthor = (card) => card.querySelector('.card-subtitle')?.innerText;
  const coreDescription = (card) => card.querySelector('.card-text')?.innerText;
  const coreCategory = (card) => card.querySelector('.card-link')?.innerText;
  const coreFooter = (card) => card.querySelector('.card-footer')?.innerText;

  const grid = document.getElementById(GRID_CORES_ID);
  const cards = Array.from(grid?.querySelectorAll('.card'));
  const visibleCards = () => Array.from(grid?.querySelectorAll('.col.d-block > .card'));

  // Search
  const search = function (call = true) {
    const match = function (card, query) {
      if (!query?.length)
        return true;

      const name = coreName(card);
      const author = coreAuthor(card);
      const description = coreDescription(card);
      const category = coreCategory(card);

      const sanitizedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
      const regex = new RegExp(sanitizedQuery, 'gi');

      return regex.test(name) || regex.test(author) || regex.test(description) || regex.test(category);
    };

    const query = document.getElementById('input-search')?.value;
    cards.forEach(function (card) {
      const isMatch = match(card, query);
      const column = card.parentNode;

      if (isMatch)
        column.classList.replace('d-none', 'd-block');
      else
        column.classList.replace('d-block', 'd-none');
    });

    if (call)
      filter(false);
  };

  // Filter
  const filter = function (call = true) {
    if (call)
      search(false);

    const match = function (card, filters) {
      if (!Array.isArray(filters) || !filters.length)
        return true;

      const category = coreCategory(card);
      return filters.includes(category);
    };

    const filters = Array.from(document.querySelectorAll('input[name=filter-platform]:checked + label')).map(x => x.innerText);
    visibleCards().forEach(function (card) {
      const isMatch = match(card, filters);
      const column = card.parentNode;

      if (!isMatch)
        column.classList.replace('d-block', 'd-none');
    });
  };

  // Sort
  const sort = function () {
    const icon = document.getElementById('button-sort')?.querySelector('i');
    const order = icon.classList.contains('bi-sort-down');

    const byAuthor = function (a, b) {
      const aAuthor = coreAuthor(a);
      const bAuthor = coreAuthor(b);

      return aAuthor.localeCompare(bAuthor, undefined, { sensitivity: 'base' }) * (order ? -1 : 1);
    };

    const byCategory = function (a, b) {
      const aCategory = coreCategory(a);
      const bCategory = coreCategory(b);

      return aCategory.localeCompare(bCategory, undefined, { sensitivity: 'base' }) * (order ? -1 : 1);
    };

    const byLatestRelease = function (a, b) {
      const aFooter = coreFooter(a);
      const bFooter = coreFooter(b);

      const aDate = Date.parse(aFooter.split(' • ')[1]);
      const bDate = Date.parse(bFooter.split(' • ')[1]);

      return order ? bDate - aDate : aDate - bDate;
    };

    const byName = function (a, b) {
      const aName = coreName(a);
      const bName = coreName(b);

      return aName.localeCompare(bName, undefined, { sensitivity: 'base' }) * (order ? -1 : 1);
    };

    const field = document.getElementById('dropdown-sort')?.value;
    let method = byLatestRelease;

    switch (field) {
      case 'author':
        method = byAuthor;
        break;
      case 'category':
        method = byCategory;
        break;
      case 'name':
        method = byName;
        break;
      case 'latest_release':
      default:
        method = byLatestRelease;
        break;
    }

    cards.sort(method).forEach((card) => grid?.appendChild(card.parentNode));
  };

  sort();
})();
