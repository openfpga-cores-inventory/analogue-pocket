---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Analogue Pocket
---
The [Analogue Pocket](https://www.analogue.co/pocket) is a multi-video-game-system portable handheld designed and built by [Analogue](https://www.analogue.co).

<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
  <li class="nav-item" role="presentation">
    <a href="#" class="nav-link active" id="gallery-tab" data-bs-toggle="pill" data-bs-target="#gallery" role="tab" aria-controls="gallery" aria-selected="true"><i class="bi bi-grid-fill"></i> Gallery</a>
  </li>
  <li class="nav-item" role="presentation">
    <a href="#" class="nav-link" id="list-tab" data-bs-toggle="pill" data-bs-target="#list" role="tab" aria-controls="list" aria-selected="false"><i class="bi bi-list"></i> List</a>
  </li>
</ul>
<div class="tab-content">
  <div class="tab-pane fade show active" id="gallery" role="tabpanel" aria-labelledby="gallery-tab">
    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
    {%- assign date_format = site.bootstrap.date_format | default: '%b %-d, %Y' -%}
    {%- for core_hash in site.data.cores -%}
      {%- assign key = core_hash[0] -%}
      {%- assign core = core_hash[1] -%}
      {%- for platform_id in core.metadata.platform_ids -%}
        {%- assign platform = site.data.platforms[platform_id] -%}
        {%- unless platform -%}
          {%- continue -%}
        {%- endunless -%}
        {%- assign core_id = core.metadata.author | append: "." | append: core.metadata.shortname -%}
        {%- assign core_slug = core_id | slugify -%}
        {%- assign post_url = site.posts | where: 'slug', core_slug | map: 'url' | first -%}
        {%- assign release = site.data.releases[key] -%}
        {%- assign repository_url = 'https://github.com/' | append: release.repository.owner | append: '/' | append: release.repository.name -%}
        {%- assign icon_path = core_id | prepend: '/assets/images/authors/' | append: '.png' -%}
        {%- assign icon_exists = site.static_files | where: 'path', icon_path | first -%}
        <div class="col">
          <div class="card h-100">
            <a href="{{ repository_url }}"><img src="{{ platform_id | prepend: '/assets/images/platforms/' | append: '.png' | relative_url }}" class="card-img-top" alt="{{ platform.name }}" /></a>
            <div class="card-body">
              <h5 class="card-title">{{ platform.name }}</h5>
              <h6 class="card-subtitle mb-2 text-body-secondary">
                {{ core.metadata.description }}
              </h6>        
              <p class="card-text">
                <a class="d-flex align-items-center text-muted text-decoration-none" href="{{ core.metadata.url | default: '#' }}" target="_blank" rel="noopener">
                  {%- if icon_exists -%}<img class="mb-0 me-2 rounded-2" src="{{ icon_path | relative_url }}" />{%- endif -%}
                  <span>{{ core.metadata.author }}</span>
                </a>
              </p>
              <a href="#" class="card-link"><span class="badge bg-secondary">{{ platform.category }}</span></a>
            </div>
            <div class="card-footer">
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <a href="{{ repository_url }}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-github" role="img" aria-label="GitHub"></i></a>
                  {%- if release.funding -%}
                  {%- assign sponsor_id = core_slug | prepend: 'sponsor-' -%}
                  <div class="btn-group">
                    <a href="#" class="btn btn-sm btn-outline-secondary dropdown-toggle" role="button" id="{{ sponsor_id }}" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-heart-fill" role="img" aria-label="Sponsor"></i></a>
                    <ul class="dropdown-menu" aria-labelledby="{{ sponsor_id }}">
                    {%- if release.funding.buy_me_a_coffee -%}
                      <li><a class="dropdown-item" href="{{ release.funding.buy_me_a_coffee }}">Buy Me a Coffee</a></li>
                    {%- endif -%}
                    {%- if release.funding.community_bridge -%}
                      <li><a class="dropdown-item" href="{{ release.funding.community_bridge }}">LFX Mentorship</a></li>
                    {%- endif -%}
                    {%- for funding_url in release.funding.github -%}
                      <li><a class="dropdown-item" href="{{ funding_url }}">GitHub Sponsors</a></li>
                    {%- endfor -%}
                    {%- if release.funding.issuehunt -%}
                      <li><a class="dropdown-item" href="{{ release.funding.issuehunt }}">IssueHunt</a></li>
                    {%- endif -%}
                    {%- if release.funding.ko_fi -%}
                      <li><a class="dropdown-item" href="{{ release.funding.ko_fi }}">Ko-fi</a></li>
                    {%- endif -%}
                    {%- if release.funding.liberapay -%}
                      <li><a class="dropdown-item" href="{{ release.funding.liberapay }}">Liberapay</a></li>
                    {%- endif -%}
                    {%- if release.funding.open_collective -%}
                      <li><a class="dropdown-item" href="{{ release.funding.open_collective }}">Open Collective</a></li>
                    {%- endif -%}
                    {%- if release.funding.patreon -%}
                      <li><a class="dropdown-item" href="{{ release.funding.patreon }}">Patreon</a></li>
                    {%- endif -%}
                    {%- if release.funding.polar -%}
                      <li><a class="dropdown-item" href="{{ release.funding.polar }}">Polar</a></li>
                    {%- endif -%}
                    {%- if release.funding.thanks_dev -%}
                      <li><a class="dropdown-item" href="{{ release.funding.thanks_dev }}">thanks.dev</a></li>
                    {%- endif -%}
                    {%- if release.funding.tidelift -%}
                      <li><a class="dropdown-item" href="{{ release.funding.tidelift }}">Tidelift</a></li>
                    {%- endif -%}
                    {%- for funding_url in release.funding.custom -%}
                      <li><a class="dropdown-item" href="{{ funding_url }}">Sponsor</a></li>
                    {%- endfor -%}
                    </ul>
                  </div>                
                  {%- endif -%}
                  <a href="{{ release.download_url }}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-download" role="img" aria-label="Download"></i></a>
                </div>
                <a class="link-secondary link-underline-secondary link-underline-opacity-0 link-underline-opacity-100-hover small" href="{{ post_url | relative_url }}">{{ core.metadata.version }} • {{ core.metadata.date_release | date: date_format }}</a>
              </div>
            </div>
          </div>
        </div>
      {%- endfor -%}
    {%- endfor -%}
    </div>
  </div>
  <div class="tab-pane fade" id="list" role="tabpanel" aria-labelledby="list-tab">
    <div class="table-responsive">
      <table class="table table-striped table-hover">
        <thead>
          <tr>
            <th>Platform</th>
            <th>Category</th>
            <th>Author</th>
            <th>Version</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
        {%- for core_hash in site.data.cores -%}
          {%- assign key = core_hash[0] -%}
          {%- assign core = core_hash[1] -%}
          {%- for platform_id in core.metadata.platform_ids -%}
            {%- assign platform = site.data.platforms[platform_id] -%}
            {%- unless platform -%}
              {%- continue -%}
            {%- endunless -%}
            {%- assign release = site.data.releases[key] -%}
            {%- assign repository_url = 'https://github.com/' | append: release.repository.owner | append: '/' | append: release.repository.name -%}
            <tr>
              <td><a href="{{ repository_url }}">{{ platform.name }}</a></td>
              <td>{{ platform.category }}</td>
              <td>{{ core.metadata.author }}</td>
              <td><a href="{{ release.download_url }}">{{ core.metadata.version }}</a></td>
              <td>{{ core.metadata.date_release | date: date_format }}</td>
            </tr>
          {%- endfor -%}
        {%- endfor -%}
        </tbody>
      </table>
    </div>
  </div>
</div>
