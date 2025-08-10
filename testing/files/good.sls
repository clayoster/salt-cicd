{% set filepath = '/path/to/file' %}
{% set testpillar = salt['pillar.get']('testpillarkey', False) %}
{# jinja comment #}

{% if grains['id'].startswith('testing') %}
{{ filepath }}:
  file.manage:
    - source: salt://path/to/file
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - content: |
        {{ testpillar }}
{% endif %}
