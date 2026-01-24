{% set filepath = '/path/to/file' %}
{% set testpillar = salt['pillar.get']('testpillarkey', False) %}
{# jinja comment #}

{% set jinja_list = [
  'test1',
  'test2',
  'test3'
] %}

{% set jinja_dict1 = {
  "test1": {},
  "test2": {},
  "test3": {}
} %}

{% set jinja_dict2 = {
  'test1': {
    'test_sub1': 'value2',
    'test_sub2': '0.0.0.0'},
  'test2': {
    'test_sub1': 'value1',
    'test_sub2': '0.0.0.0' }} %}

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
