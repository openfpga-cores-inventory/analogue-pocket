---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Analogue Pocket
---

The [Analogue Pocket](https://www.analogue.co/pocket) is a multi-video-game-system portable handheld designed and built by [Analogue](https://www.analogue.co).

<div class="row">
  <div class="col-md-9 mb-2">
    <div class="input-group">
      <input id="input-search" type="text" class="form-control" placeholder="Search" aria-label="Search" aria-describedby="button-search">
      <button id="button-search" type="button" class="btn btn-secondary"><i class="bi bi-search" role="img" aria-label="Search"></i></button>
    </div>
  </div>
  <div class="col-md-3 mb-2">
    <label class="visually-hidden" for="dropdown-sort">Sort by</label>
    <div class="input-group">
      <select id="dropdown-sort" class="form-select">
        <option value="author">Author</option>
        <option value="category">Category</option>
        <option value="latest_release" selected="selected">Latest Release</option>
        <option value="name">Name</option>
      </select>
      <button id="button-sort" class="btn btn-secondary" type="button"><i class="bi bi-sort-down" role="img" aria-label="Descending"></i></button>
    </div>
  </div>
</div>

{% assign cores = site.data.cores | map: 'cores' | compact -%}
{% assign platforms = cores | map: 'platform' -%}
{% assign categories = platforms | map: 'category' | uniq | sort -%}

<div class="row row-cols-1 row-cols-md-2">
  <div class="col mb-1">
    <fieldset>
      <legend class="visually-hidden">Filter by Category</legend>
    {% for category in categories -%}
      {% assign filter_id = category | slugify | prepend: 'filter-' -%}
      <input id="{{ filter_id }}" type="checkbox" class="btn-check" name="filter-platform" autocomplete="off">
      <label class="btn btn-outline-secondary mb-1" for="{{ filter_id }}">{{ category }}</label>
    {% endfor -%}
    </fieldset>
  </div>
  <div class="col mb-2">
    <div class="btn-group float-md-end" role="tablist">
      <input type="radio" class="btn-check active" name="display-cores" id="button-gallery-tab" data-bs-toggle="tab" data-bs-target="#tab-gallery" role="tab" aria-controls="tab-gallery" aria-selected="true" autocomplete="off" checked>
      <label class="btn btn-outline-secondary" for="button-gallery-tab"><i class="bi bi-grid-fill"></i> Gallery</label>
      <input type="radio" class="btn-check" name="display-cores" id="button-list-tab" data-bs-toggle="tab" data-bs-target="#tab-list" role="tab" aria-controls="tab-list" aria-selected="false" autocomplete="off">
      <label class="btn btn-outline-secondary" for="button-list-tab"><i class="bi bi-list"></i> List</label>
    </div>
  </div>
</div>

<div class="tab-content">
  <div class="tab-pane fade show active" id="tab-gallery" role="tabpanel" aria-labelledby="button-gallery-tab">
    <div id='gallery-cores' class="row row-cols-1 row-cols-md-3 g-4 mb-5">
    {% for developer in site.data.cores -%}
      {% assign cores = developer.cores -%}
      {% for core in cores -%}
        {% assign core_id = core.id | slugify -%}
        {% assign author_url = 'https://github.com/' | append: developer.username -%}
        {% assign repository_url = author_url | append: '/' | append: core.repository.name -%}
    <div class="col d-block">
      <div class="card h-100">
        <a href="{{ repository_url }}"><img src="{{ core.platform_id | prepend: '/assets/images/platforms/' | append: '.png' | relative_url }}" class="card-img-top" alt="{{ core.platform.name }}" /></a>
        <div class="card-body">
          <h5 class="card-title"><span class="me-2">{{ core.display_name }}</span>{% if core.requires_license -%}<i class="bi bi-lock-fill" data-bs-toggle="tooltip" data-bs-title="License Required"></i>{% endif -%}</h5>
          {% assign icon_path = core.id | prepend: '/assets/images/authors/' | append: '.png' -%}
          {% assign icon_exists = site.static_files | where: 'path', icon_path | first -%}
          <h6 class="card-subtitle mb-2 text-muted">{{ core.description }}</h6>
          <p class="card-text">{% if icon_exists -%}<a href="{{ author_url }}" class="me-2"><img src="{{ icon_path | relative_url }}" alt="{{ developer.username }}" class="rounded" /></a>{% endif -%}<a href="{{ author_url }}">{{ developer.username }}</a></p>
          <a href="#" class="card-link"><span class="badge bg-secondary">{{ core.platform.category }}</span></a>
        </div>
        <div class="card-footer text-muted">
          <div class="d-flex justify-content-between align-items-center">
            <ul class="list-inline mb-0">
              <li class="list-inline-item"><a href="{{ repository_url }}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-github" role="img" aria-label="GitHub"></i></a></li>
            {% if core.sponsor -%}            
              {% assign sponsor_id = core_id | prepend: 'sponsor-' -%}
              <li class="list-inline-item">
                <div class="dropdown">
                  <a class="btn btn-sm btn-outline-danger dropdown-toggle" href="#" role="button" id="{{ sponsor_id }}" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi-heart-fill" role="img" aria-label="Sponsor"></i></a>
                  <ul class="dropdown-menu" aria-labelledby="{{ sponsor_id }}">
              {% if core.sponsor.community_bridge -%}
                    <li><a class="dropdown-item" href="{{ core.sponsor.community_bridge }}">LFX Mentorship</a></li>
              {% endif -%}
              {% for sponsor_url in core.sponsor.github -%}
                    <li><a class="dropdown-item" href="{{ sponsor_url }}">GitHub Sponsors</a></li>
              {% endfor -%}
              {% if core.sponsor.issuehunt -%}
                    <li><a class="dropdown-item" href="{{ core.sponsor.issuehunt }}">IssueHunt</a></li>
              {% endif -%}
              {% if core.sponsor.ko_fi -%}
                    <li><a class="dropdown-item" href="{{ core.sponsor.ko_fi }}">Ko-fi</a></li>
              {% endif -%}
              {% if core.sponsor.liberapay -%}
                    <li><a class="dropdown-item" href="{{ core.sponsor.liberapay }}">Liberapay</a></li>
              {% endif -%}
              {% if core.sponsor.open_collective -%}
                    <li><a class="dropdown-item" href="{{ core.sponsor.open_collective }}">Open Collective</a></li>
              {% endif -%}
              {% if core.sponsor.otechie -%}
                    <li><a class="dropdown-item" href="{{ core.sponsor.otechie }}">Otechie</a></li>
              {% endif -%}
              {% if core.sponsor.patreon -%}
                    <li><a class="dropdown-item" href="{{ core.sponsor.patreon }}">Patreon</a></li>
              {% endif -%}
              {% if core.sponsor.tidelift -%}
                    <li><a class="dropdown-item" href="{{ core.sponsor.tidelift }}">Tidelift</a></li>
              {% endif -%}
              {% for sponsor_url in core.sponsor.custom -%}
                    <li><a class="dropdown-item" href="{{ sponsor_url }}">Sponsor</a></li>
              {% endfor -%}
                  </ul>
                </div>
              </li>            
            {% endif -%}
              <li class="list-inline-item"><a href="{{ core.download_url }}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-download" role="img" aria-label="Download"></i></a></li>
            </ul>
            <small>{{ core.version }} • {{ core.date_release | date: "%b %-d, %Y" }}</small>
          </div>
        </div>
      </div>
    </div>    
      {% endfor -%}
    {% endfor -%}          
  </div>
  </div>
  <div class="tab-pane fade" id="tab-list" role="tabpanel" aria-labelledby="button-list-tab">
    <div class="table-responsive">
      <table id="list-cores" class="table table-hover">
        <thead>
          <tr>
            <th>Name</th>
            <th>Platform</th>
            <th>Category</th>
            <th>Author</th>
            <th>Version</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          {% for developer in site.data.cores -%}
            {% for core in developer.cores -%}
              <tr class="d-table-row">
                <td>
                  <a href="https://github.com/{{ developer.username }}/{{ core.repository.name }}">{{ core.display_name }}</a>
                  {% if core.requires_license -%}
                    <i class="bi bi-lock-fill" data-bs-toggle="tooltip" data-bs-title="License Required"></i>
                  {% endif -%}
                </td>
                <td>{{ core.platform.name }}</td>
                <td>{{ core.platform.category }}</td>
                <td><a href="https://github.com/{{ developer.username }}">{{ developer.username }}</a></td>
                <td><a href="{{core.download_url}}">{{ core.version }}</a></td>
                <td>{{ core.date_release | date: "%b %-d, %Y" }}</td>
              </tr>
            {% endfor -%}
          {% endfor -%}
        </tbody>
      </table>
    </div>
  </div>
</div>
