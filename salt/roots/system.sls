America/Los_Angeles:
  timezone.system:
    - utc: True

tops:
  pkg.installed:
    - pkgs:
      - htop
      - iftop

silversearcher-ag:
  pkg.installed:
{%- if grains['oscodename'] == 'wheezy' %}
    - sources:
      - the-silver-searcher: http://swiftsignal.com/packages/ubuntu/quantal/the-silver-searcher_0.14-1_amd64.deb
{%- endif %}

sshfs:
  pkg.installed

unzip:
  pkg.installed

vim-gtk:
  pkg.installed
