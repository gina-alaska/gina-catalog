GINA Catalog - Management Documentation
=======================================

_Collections List_

To list the collections in the system in a page with links to the search, use the following Liquid/HTML code:

`<ul>
{% for collection in setup.catalog_collections %}
  <li>
    <a href="/search?search[catalog_collection_ids]={{collection.id}}">
      {{ collection.name }}
    </a>
  </li>
{% endfor %}
</ul>`

