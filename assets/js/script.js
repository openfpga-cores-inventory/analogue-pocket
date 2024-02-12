(function () {
  // Search Input
  document.getElementById('input-search')?.addEventListener('input', function (e) {
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

  // Tooltips
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(item => new bootstrap.Tooltip(item));

  const GALLERY_CORES_ID = 'gallery-cores';
  const LIST_CORES_ID = 'list-cores';

  const TAB_GALLERY = 'gallery';
  const TAB_LIST = 'list';

  const GALLERY_ITEM_SELECTOR = '.col';
  const GALLERY_NAME_SELECTOR = '.card-title';
  const GALLERY_AUTHOR_SELECTOR = '.card-text';
  const GALLERY_DESCRIPTION_SELECTOR = '.card-subtitle';
  const GALLERY_CATEGORY_SELECTOR = '.card-link';
  const GALLERY_DATE_SELECTOR = '.card-footer';

  const LIST_ITEM_SELECTOR = 'tbody > tr';
  const LIST_NAME_SELECTOR = 'td:nth-child(1)';
  const LIST_AUTHOR_SELECTOR = 'td:nth-child(4)';
  const LIST_CATEGORY_SELECTOR = 'td:nth-child(3)';
  const LIST_DATE_SELECTOR = 'td:nth-child(6)';

  const gallery = document.getElementById(GALLERY_CORES_ID);
  const list = document.getElementById(LIST_CORES_ID);

  const items = (tab) => Array.from(isList(tab) ? list?.querySelectorAll(LIST_ITEM_SELECTOR) : gallery?.querySelectorAll(GALLERY_ITEM_SELECTOR));
  const visibleItems = (tab) => items(tab).filter(item => item.classList.contains('d-block') || item.classList.contains('d-table-row'));

  const isList = (tab) => tab === TAB_LIST;
  const itemName = (item, tab) => isList(tab) ? item.querySelector(LIST_NAME_SELECTOR)?.innerText : item.querySelector(GALLERY_NAME_SELECTOR)?.innerText;
  const itemAuthor = (item, tab) => isList(tab) ? item.querySelector(LIST_AUTHOR_SELECTOR)?.innerText : item.querySelector(GALLERY_AUTHOR_SELECTOR)?.innerText;
  const itemDescription = (item, tab) => isList(tab) ? null : item.querySelector(GALLERY_DESCRIPTION_SELECTOR)?.innerText;
  const itemCategory = (item, tab) => isList(tab) ? item.querySelector(LIST_CATEGORY_SELECTOR)?.innerText : item.querySelector(GALLERY_CATEGORY_SELECTOR)?.innerText;
  const itemDate = (item, tab) => isList(tab) ? item.querySelector(LIST_DATE_SELECTOR)?.innerText : item.querySelector(GALLERY_DATE_SELECTOR)?.innerText;

  // Search
  const search = function (call = true) {
    const match = function (item, tab, query) {
      if (!query?.length)
        return true;

      const name = itemName(item, tab);
      const author = itemAuthor(item, tab);
      const description = itemDescription(item, tab);
      const category = itemCategory(item, tab);

      const sanitizedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
      const regex = new RegExp(sanitizedQuery, 'gi');

      return regex.test(name) || regex.test(author) || regex.test(description) || regex.test(category);
    };

    const searchGallery = (query) => {
      items(TAB_GALLERY).forEach(function (item) {
        const isMatch = match(item, TAB_GALLERY, query);

        if (isMatch)
          item.classList.replace('d-none', 'd-block');
        else
          item.classList.replace('d-block', 'd-none');
      });
    };

    const searchList = (query) => {
      items(TAB_LIST).forEach(function (item) {
        const isMatch = match(item, TAB_LIST, query);

        if (isMatch)
          item.classList.replace('d-none', 'd-table-row');
        else
          item.classList.replace('d-table-row', 'd-none');
      });
    }

    const query = document.getElementById('input-search')?.value;
    searchGallery(query);
    searchList(query);

    if (call)
      filter(false);
  };

  // Filter
  const filter = function (call = true) {
    if (call)
      search(false);

    const match = function (item, tab, filters) {
      if (!Array.isArray(filters) || !filters.length)
        return true;

      const category = itemCategory(item, tab);
      return filters.includes(category);
    };

    const filterItems = (tab, filters) => visibleItems(tab).filter(item => !match(item, tab, filters));
    const filterGallery = (filters) => filterItems(TAB_GALLERY, filters).forEach(item => item.classList.replace('d-block', 'd-none'));
    const filterList = (filters) => filterItems(TAB_LIST, filters).forEach(item => item.classList.replace('d-table-row', 'd-none'));

    const filters = Array.from(document.querySelectorAll('input[name=filter-platform]:checked + label')).map(x => x.innerText);
    filterGallery(filters);
    filterList(filters);
  };

  // Sort
  const sort = function () {
    const icon = document.getElementById('button-sort')?.querySelector('i');
    const order = icon.classList.contains('bi-sort-down');

    const compare = (a, b) => a.localeCompare(b, undefined, { sensitivity: 'base' }) * (order ? -1 : 1);

    const byAuthor = (tab) => function (a, b) {
      const aAuthor = itemAuthor(a, tab);
      const bAuthor = itemAuthor(b, tab);

      return compare(aAuthor, bAuthor);
    };

    const byCategory = (tab) => function (a, b) {
      const aCategory = itemCategory(a, tab);
      const bCategory = itemCategory(b, tab);

      return compare(aCategory, bCategory);
    };

    const byLatestRelease = (tab) => function (a, b) {
      const aFooter = itemDate(a, tab);
      const bFooter = itemDate(b, tab);

      const aDate = Date.parse(aFooter.split(' • ').pop());
      const bDate = Date.parse(bFooter.split(' • ').pop());

      return order ? bDate - aDate : aDate - bDate;
    };

    const byName = (tab) => function (a, b) {
      const aName = itemName(a, tab);
      const bName = itemName(b, tab);

      return compare(aName, bName);
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

    const sortGallery = () => items(TAB_GALLERY).sort(method(TAB_GALLERY)).forEach(item => gallery?.appendChild(item));
    const sortList = () => items(TAB_LIST).sort(method(TAB_LIST)).forEach(item => list?.querySelector('tbody')?.appendChild(item));

    sortGallery();
    sortList();
  };

  sort();
})();
