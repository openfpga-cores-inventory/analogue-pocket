---
layout: page
title: Computer
---

<div class="row row-cols-1 row-cols-md-3 g-4">
{%- assign category = "Computer" -%}
{%- for core_hash in site.data.cores -%}
  {%- assign core = core_hash[1] -%}
  {%- for platform_id in core.metadata.platform_ids -%}
    {%- assign platform = site.data.platforms[platform_id] -%}
    {%- unless platform.category == category -%}
      {%- continue -%}
    {%- endunless -%}
    {%- assign core_id = core.metadata.author | append: "." | append: core.metadata.shortname -%}
    {%- assign icon_path = core_id | prepend: '/assets/images/authors/' | append: '.png' -%}
    {%- assign icon_exists = site.static_files | where: 'path', icon_path | first -%}
    <div class="col">
      <div class="card h-100">
        <img src="{{ platform_id | prepend: '/assets/images/platforms/' | append: '.png' | relative_url }}" class="card-img-top" alt="{{ platform.name }}">
        <div class="card-body">
          <h5 class="card-title">{{ core.metadata.shortname }}</h5>
          <h6 class="card-subtitle mb-2 text-body-secondary">
            {%- if icon_exists -%}<img src="{{ icon_path | relative_url }}" alt="{{ core.metadata.author }}" class="rounded me-2" />{%- endif -%}
            {{ core.metadata.author }}
          </h6>
          <p class="card-text">{{ core.metadata.description }}</p>
          <a href="#" class="card-link"><span class="badge bg-secondary">{{ platform.category }}</span></a>
        </div>
        <div class="card-footer">
          <div class="d-flex justify-content-between align-items-center">
            <div class="btn-group">
              <a href="#" class="btn btn-sm btn-outline-secondary"><i class="bi bi-github" role="img" aria-label="GitHub"></i></a>
              <a href="#" class="btn btn-sm btn-outline-secondary"><i class="bi-heart-fill" role="img" aria-label="Sponsor"></i></a>
              <a href="#" class="btn btn-sm btn-outline-secondary"><i class="bi bi-download" role="img" aria-label="Download"></i></a>
            </div>
            <small class="text-muted">{{ core.metadata.version }} • {{ core.metadata.date_release | date: "%B %-d, %Y" }}</small>
          </div>
        </div>
      </div>
    </div>
  {%- endfor -%}
{%- endfor -%}
</div>
