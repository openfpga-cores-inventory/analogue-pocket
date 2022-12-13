const filters = new Set();

function initializeDatatables() {
  $(".datatable").DataTable({
    fixedHeader: true,
    info: false,
    paging: false,
    scrollX: true,
    columnDefs: [
      { targets: 'no-sort', orderable: false },
      { className: "dt-nowrap", targets: 5 },
      { visible: false, targets: 2 },
    ],
    language: {
      search: "",
      searchPlaceholder: "Search cores"
    }
  });
}

function toggleFilter(chip, category) {
  filters.has(category) ? filters.delete(category) : filters.add(category);

  const table = $(".datatable").DataTable({ retrieve: true });
  const input = filters.size > 0 ? `^(${[...filters].join("|")})$` : "";
  table.column(2).search(input, true, false).draw();

  $(chip).toggleClass("active");
  $(".md-chip-remove", chip).toggle();
}

function createChip(category) {
  return $(
    $.parseHTML(
      $.trim(`
        <div class="md-chip md-chip-clickable">
          <div class="md-chip-remove" style="display: none;">
            <img class="md-chip-icon" src="assets/images/check.svg">
          </div>
          ${category}
        </div>
      `)
    )
  );
}

document.addEventListener("DOMContentLoaded", () => {
  initializeDatatables()

  const table = $(".datatable").DataTable({ retrieve: true });
  const data = table.column(2).data().filter(category => category !== "").unique().sort().toArray();
  const categories = [...new Set(data)];

  const container = $(`<div class="filters"></div>`);
  categories.forEach(category => {
    const chip = createChip(category);
    chip.click(() => toggleFilter(chip, category));
    container.append(chip);
  });
  $(table.table().container()).prepend(container);
});
