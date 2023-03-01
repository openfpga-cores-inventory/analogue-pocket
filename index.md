---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Analogue Pocket
---

The [Analogue Pocket](https://www.analogue.co/pocket) is a multi-video-game-system portable handheld designed and built by [Analogue](https://www.analogue.co).

<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
  <li class="nav-item" role="presentation">
    <button class="nav-link active" id="cores-gallery-tab" data-bs-toggle="pill" data-bs-target="#cores-gallery" type="button" role="tab" aria-controls="cores-gallery" aria-selected="true"><i class="bi bi-grid-fill"></i> Gallery</button>
  </li>
  <li class="nav-item" role="presentation">
    <button class="nav-link" id="cores-list-tab" data-bs-toggle="pill" data-bs-target="#cores-list" type="button" role="tab" aria-controls="cores-list" aria-selected="false"><i class="bi bi-list"></i> List</button>
  </li>
</ul>
<div class="tab-content mb-5" id="cores-tabContent">
  <div class="tab-pane fade show active" id="cores-gallery" role="tabpanel" aria-labelledby="cores-gallery-tab">
    {% assign cores = site.data.cores | map: 'cores' | compact -%}
    {% assign platforms = cores | map: 'platform' -%}
    {% assign categories = platforms | map: 'category' | uniq | sort -%}
    {% for category in categories -%}
    <h2>{{ category }}</h2>
    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
      {% for developer in site.data.cores -%}
        {% assign cores = developer.cores | where: 'platform.category', category -%}
        {% for core in cores -%}
      <div class="col">
        <div class="card bg-light h-100">
          <img src="{{ core.platform_id | prepend: '/assets/images/platforms/' | append: '.png' | relative_url }}" class="card-img-top" alt="{{ core.platform.name }}" />
          <div class="card-body">
            <h5 class="card-title">{{ core.display_name }}</h5>
            {% assign icon_path = core.id | prepend: '/assets/images/authors/' | append: '.png' -%}
            {% assign icon_exists = site.static_files | where: 'path', icon_path | first -%}
            {% capture author_url -%}{{ 'https://github.com/' | append: developer.username }}{% endcapture -%}
            <h6 class="card-subtitle mb-2 text-muted">{% if icon_exists -%}<img src="{{ icon_path | relative_url }}" alt="{{ developer.username }}" class="rounded" /> {% endif -%}<a href="{{ author_url }}">{{ developer.username }}</a></h6>
            <p class="card-text">{{ core.description }}</p>
            <a href="#" class="card-link"><span class="badge bg-secondary">{{ core.platform.category }}</span></a>
          </div>
          <div class="card-footer text-muted">
            <div class="d-flex justify-content-between align-items-center">
              <div class="btn-toolbar" role="toolbar">
                <div class="btn-group me-2">
                  {% capture repository_url -%}{{ author_url | append: '/' | append: core.repository.name }}{% endcapture -%}
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
              <small class="text-muted">{{ core.version }} • {{ core.date_release | date: "%b %-d, %Y" }}</small>
            </div>
          </div>
        </div>
      </div>
        {% endfor -%}
      {% endfor -%}
    </div>
    {% endfor -%}
  </div>
  <div class="tab-pane fade" id="cores-list" role="tabpanel" aria-labelledby="cores-list-tab">
    <table class="datatable table table-striped" style="width:100%">
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
            <tr>
              <td><a href="https://github.com/{{ developer.username }}/{{ core.repository.name }}">{{ core.display_name }}</a></td>
              <td>{{ core.platform.name }}</td>
              <td>{{ core.platform.category }}</td>
              <td><a href="https://github.com/{{ developer.username }}">{{ developer.username }}</a></td>
              <td data-order="{{ core.version }}">
                <a href="{{core.download_url}}">{{ core.version }}</a>
              </td>
              <td data-order="{{ core.date_release | date: "%s" }}">
                {{ core.date_release | date: "%b %-d, %Y" }}
              </td>
            </tr>
          {% endfor -%}
        {% endfor -%}
      </tbody>
    </table>
  </div>
</div>

<script type="text/javascript" src="{{ "/assets/js/script.js" | relative_url }}"></script>
