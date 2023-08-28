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
      <button id="button-search" type="button" class="btn btn-primary"><i class="bi bi-search" role="img" aria-label="Search"></i></button>
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
      <button id="button-sort" class="btn btn-primary" type="button"><i class="bi bi-sort-down" role="img" aria-label="Descending"></i></button>
    </div>
  </div>
</div>

{% assign cores = site.data.cores | map: 'cores' | compact -%}
{% assign platforms = cores | map: 'platform' -%}
{% assign categories = platforms | map: 'category' | uniq | sort -%}

<div class="row">
  <div class="col mb-1">
    <fieldset>
      <legend class="visually-hidden">Filter by Category</legend>
    {% for category in categories -%}
      {% assign input_id = category | slugify | prepend: 'input-' -%}
      <input id="{{ input_id }}" type="checkbox" class="btn-check" name="filter-platform" autocomplete="off">
      <label class="btn btn-outline-secondary mb-1" for="{{ input_id }}">{{ category }}</label>
    {% endfor -%}
    </fieldset>
  </div>
</div>

<div id='grid-cores' class="row row-cols-1 row-cols-md-3 g-4 mb-5">
  {% for developer in site.data.cores -%}
    {% assign cores = developer.cores -%}
    {% for core in cores -%}
      {% assign author_url = 'https://github.com/' | append: developer.username -%}
      {% assign repository_url = author_url | append: '/' | append: core.repository.name -%}
  <div class="col d-block">
    <div class="card bg-light h-100">
      <a href="{{ repository_url }}"><img src="{{ core.platform_id | prepend: '/assets/images/platforms/' | append: '.png' | relative_url }}" class="card-img-top" alt="{{ core.platform.name }}" /></a>
      <div class="card-body">
        <h5 class="card-title">{{ core.display_name }}</h5>
        {% assign icon_path = core.id | prepend: '/assets/images/authors/' | append: '.png' -%}
        {% assign icon_exists = site.static_files | where: 'path', icon_path | first -%}
        <h6 class="card-subtitle mb-2 text-muted">{% if icon_exists -%}<a href="{{ author_url }}" class="me-1"><img src="{{ icon_path | relative_url }}" alt="{{ developer.username }}" class="rounded" /></a>{% endif -%}<a href="{{ author_url }}">{{ developer.username }}</a></h6>
        <p class="card-text">{{ core.description }}</p>
        <a href="#" class="card-link"><span class="badge bg-secondary">{{ core.platform.category }}</span></a>
      </div>
      <div class="card-footer text-muted">
        <div class="d-flex justify-content-between align-items-center">
          <div class="btn-toolbar" role="toolbar">
            <div class="btn-group me-2">
              <a href="{{ repository_url }}" class="btn btn-sm btn-dark"><i class="bi bi-github" role="img" aria-label="GitHub"></i></a>
            </div>
            {% if core.sponsor -%}
            <div class="btn-group me-2">
              <div class="dropdown">
                <a class="btn btn-sm btn-danger dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi-heart-fill" role="img" aria-label="Sponsor"></i></a>
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
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
            </div>
            {% endif -%}
            <div class="btn-group">
              <a href="{{ core.download_url }}" class="btn btn-sm btn-secondary"><i class="bi bi-download" role="img" aria-label="Download"></i></a>
            </div>
          </div>
          <small>{{ core.version }} • {{ core.date_release | date: "%b %-d, %Y" }}</small>
        </div>
      </div>
    </div>
  </div>    
    {% endfor -%}
  {% endfor -%}          
</div>

<script type="text/javascript" src="{{ '/assets/js/script.js' | relative_url }}"></script>
