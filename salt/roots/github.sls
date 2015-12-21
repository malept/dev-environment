github-hub:
  archive.extracted:
    - name: /opt/github/
    - source: https://github.com/github/hub/releases/download/v2.2.2/hub-linux-amd64-2.2.2.tgz
    - source_hash: sha256=da2d780f6bca22d35fdf71c8ba1d11cfd61078d5802ceece8d1a2c590e21548d
    - archive_format: tar
    - tar_options: -z --strip-components=1
