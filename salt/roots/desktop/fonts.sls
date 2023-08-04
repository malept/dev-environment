font-packages:
  pkg.installed:
    - pkgs:
      # multipurpose
      - fonts-noto
      - fonts-roboto
      # console/programming
      - fonts-droid-fallback
      # emoji
      - fonts-knda
      - fonts-lklug-sinhala
      - fonts-noto-color-emoji
      - fonts-tibetan-machine
      - fonts-vlgothic
      - ttf-ancient-fonts
      - unifont

{% set user_font_dir = "/home/{}/.local/share/fonts".format(grains['username']) %}
user-font-dir:
  file.directory:
    - name: {{ user_font_dir }}
    - user: {{ grains['username'] }}

font-droid-sans-mono-slashed:
  archive.extracted:
    - name: {{ user_font_dir }}
    - source: http://www.cosmix.org/software/files/DroidSansMonoSlashed.zip
    - source_hash: sha256=71768814dc4de0ea6248d09a2d2285bd47e9558f82945562eb78487c71348107
    - archive_format: zip
    - enforce_toplevel: false
    - if_missing: {{ user_font_dir }}/DroidSansMonoSlashed.ttf
    - require:
      - pkg: unzip
      - file: user-font-dir

font-fira:
  archive.extracted:
    - name: {{ user_font_dir }}
    - source: https://github.com/mozilla/Fira/archive/4.202.tar.gz
    - source_hash: sha256=d86269657387f144d77ba12011124f30f423f70672e1576dc16f918bb16ddfe4
    - archive_format: tar
    - enforce_toplevel: false
    - source_hash_update: true
    - options: --wildcards *.ttf --strip-components 2
    - if_missing: {{ user_font_dir }}/FiraMono-Regular.ttf
    - require:
      - file: user-font-dir

font-fira-code-nerdfont:
  archive.extracted:
    - name: {{ user_font_dir }}
    - source: https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.tar.xz
    - source_hash: sha256=76c1d691cea44b0cae4d6add56bb3ef52b83cedebb1c5f519b62d068f8586b93
    - archive_format: tar
    - enforce_toplevel: false
    - source_hash_update: true
    - options: --wildcards *.ttf
    - require:
      - file: user-font-dir

# Disabled until https://github.com/saltstack/salt/issues/57461 is fixed
#
# font-fira-code:
#   archive.extracted:
#     - name: {{ user_font_dir }}
#     - source: https://github.com/tonsky/FiraCode/releases/download/5.2/Fira_Code_v5.2.zip
#     - source_hash: sha256=521a72be00dd22678d248e63f817c0c79c1b6f23a4fbd377eba73d30cdca5efd
#     - archive_format: zip

#     - source_hash_update: true
#     - enforce_toplevel: false
#     - options: -j */*.ttf
#     - if_missing: {{ user_font_dir }}/FiraCode-Regular.ttf
#     - require:
#       - pkg: unzip
#       - file: user-font-dir
