macro current_platform
  {% if flag?(:win32) %}
    {"win32", win32 || unix}
  {% elsif flag?(:linux) %}
    {"linux", linux || unix}
  {% elsif flag?(:darwin) %}
    {"darwin", darwin || unix}
  {% elsif flag?(:android) %}
    {"android", android || unix}
  {% elsif flag?(:freebsd) %}
    {"freebsd", freebsd || unix}
  {% elsif flag?(:openbsd) %}
    {"openbsd", openbsd || unix}
  {% elsif flag?(:netbsd) %}
    {"netbsd", netbsd || unix}
  {% elsif flag?(:dragonfly) %}
    {"dragonfly", dragonfly || unix}
  {% else %}
    {"your-os", unix}
  {% end %}
end
