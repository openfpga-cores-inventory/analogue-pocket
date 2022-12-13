---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Analogue Pocket
---

The [Analogue Pocket](https://www.analogue.co/pocket) is a multi-video-game-system portable handheld designed and built by [Analogue](https://www.analogue.co).

## Cores

<table class="datatable">
  <thead>
    <tr>
      <th>Name</th>
      <th>Platform</th>
      <th>Category</th>
      <th>Author</th>
      <th>Version</th>
      <th>Date</th>
      <th>API</th>
    </tr>
  </thead>
  <tbody>
    {% for developer in site.data.cores -%}
      {% for core in developer.cores -%}
        {%- if core.prerelease %}
          {% assign metadata = core.prerelease %}
        {%- else %}
          {%- assign metadata = core.release %}
        {%- endif %}
        <tr>
          <td><a href="https://github.com/{{ developer.username }}/{{ core.repository }}">{{ core.display_name }}</a></td>
          <td>{{ metadata.platform.name }}</td>
          <td>{{ metadata.platform.category }}</td>
          <td><a href="https://github.com/{{ developer.username }}">{{ developer.username }}</a></td>
          <td data-order="{{ metadata.tag_name | remove_first: "v" }}">
            <a href="https://github.com/{{ developer.username }}/{{ core.repository }}/releases/latest">{{ metadata.tag_name }}</a>
          </td>
          <td data-order="{{ metadata.release_date | date: "%s" }}">
            {{ metadata.release_date | date: "%b %-d, %Y" }}
          </td>
          <td class="check" data-order="1">&#10003;</td>
        </tr>
      {% endfor -%}
    {% endfor -%}
    {% for developer in site.data.other -%}
      {% for core in developer.cores -%}
        <tr>
          <td><a href="{{ core.repository_url }}">{{ core.display_name }}</a></td>
          <td>{{ core.platform }}</td>
          <td>{{ core.category }}</td>
          <td><a href="https://github.com/{{ developer.username }}">{{ developer.username }}</a></td>
          <td data-order="{{ core.version }}">
            <a href="{{ core.release_url }}">{{ core.version }}</a>
          </td>
          <td data-order="{{ core.release_date | date: "%s" }}">
            {{ core.release_date | date: "%b %-d, %Y" }}
          </td>
          <td data-order="0"></td>
        </tr>
      {% endfor -%}
    {% endfor -%}
  </tbody>
</table>

<script type="text/javascript" src="{{ "/assets/js/script.js" | relative_url }}"></script>
