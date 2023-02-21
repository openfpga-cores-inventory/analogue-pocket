---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Analogue Pocket
---

The [Analogue Pocket](https://www.analogue.co/pocket) is a multi-video-game-system portable handheld designed and built by [Analogue](https://www.analogue.co).

## Cores

<div class="mb-5">
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

<script type="text/javascript" src="{{ "/assets/js/script.js" | relative_url }}"></script>
