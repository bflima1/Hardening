#!/usr/bin/env/bash

# Declaração de variáveis
ISSUE=$(find /etc/ -iname issue)
ISSUENET=$(find /etc/ -iname issue.net)
MOTD=$(find /etc/ -iname motd)
SSH_CONFIG=$(find /etc -iname sshd_config)

echo "Acesso ao sistema monitorado" > "$ISSUE"
echo "Acesso ao sistema monitorado" > "$ISSUENET"
echo "Acesso ao sistema monitorado" > "$MOTD"

# Hardening ssh

which /usr/sbin/sshd || { apt-update -y ; apt install openssh-server ; }


cp "$SSH_CONFIG"{,.bak}

sed -i 's/^#Port.*/Port 10443/'                                 "$SSH_CONFIG"
sed -i 's/^#ClientAliveInterval.*/ClientAliveInterval 300/'     "$SSH_CONFIG"
sed -i 's/^#MaxSessions.*/MaxSessions 2/'                       "$SSH_CONFIG"
sed -i 's/^#MaxAuthTries.*/MaxAuthTries 3/'                     "$SSH_CONFIG"
sed -i 's/^#Compression.*/Compression no/'                      "$SSH_CONFIG"
sed -i 's/^#LogLevel.*/LogLevel verbose/'                       "$SSH_CONFIG"
sed -i 's/^#TCPKeepAlive.*/TCPKeepAlive no/'                    "$SSH_CONFIG"
sed -i 's/^#LoginGraceTime.*/LoginGraceTime 20/'                "$SSH_CONFIG"
sed -i 's/^X11Forwarding.*/X11Forwarding no/'                   "$SSH_CONFIG"
sed -i 's/^#AllowTcpForwarding.*/AllowTcpForwarding no/'        "$SSH_CONFIG"
sed -i 's/^#PermitTunnel.*/PermitTunnel no/'                    "$SSH_CONFIG"
sed -i 's/^#AllowAgentForwarding.*/AllowAgentForwarding no/'    "$SSH_CONFIG"

systemctl restart ssh && systemctl enable ssh


# Criar usário para acesso exclusivo ao ssh
echo "Deseja cadastrar usuário para acesso ao servidor ssh: S/n: "
read -r ESCOLHA
ESCOLHA=${ESCOLHA:=s}

# Se escolha deiferente de 0, sai do programa
[[ ${ESCOLHA,,} != 's' ]] && { systemctl restart ssh && systemctl enable ssh ; echo "Script finalizado" ; exit 0 ; }

# Adicionar usuário no arquivo ssh
USER_SSH="lc"
grep "$USER_SSH" /etc/passwd || { clear ; echo 'Cadastrar novo usário para acessar o ssh' ; useradd "$USER_SSH" && passwd "$USER_SSH" ; }
echo "AllowUsers $USER_SSH" >> "$SSH_CONFIG"
