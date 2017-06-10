# vim: set shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent syntax=yaml:

install-intellij:
  cmd.run:
    - name: |
        rm -rf ~/.local/share/intellij
        URL=$(curl -s "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release" | jq -r '.IIC[0].downloads.linuxWithoutJDK.link')
        curl -s -o /tmp/intellij.tar.gz -L "$URL"
        mkdir -p ~/.local/share/intellij
        cd ~/.local/share/intellij
        tar --strip-components 1 -xzf /tmp/intellij.tar.gz
        rm -f /tmp/intellij.tar.gz
    - runas: {{ pillar['user'] }}
