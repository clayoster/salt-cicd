/path/to/file:
  file.manage
    - source: salt://path/to/file
    - template: jinja
    - user: root
    - group: root
    - mode: 600