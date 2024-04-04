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
systemctl restart ssh && systemctl enable ssh


cp "$SSH_CONFIG"{,.bak}

sed -i 's/^#ClientAliveInterval.*/ClientAliveInterval 300/'     "$SSH_CONFIG"
sed -i 's/^#MaxAuthTries.*/MaxAuthTries 3/'                     "$SSH_CONFIG"
sed -i 's/^#LoginGraceTime.*/LoginGraceTime 20/'                "$SSH_CONFIG"
sed -i 's/^X11Forwarding.*/X11Forwarding no/'                   "$SSH_CONFIG"
sed -i 's/^#AllowTcpForwarding.*/AllowTcpForwarding no/'        "$SSH_CONFIG"
sed -i 's/^#PermitTunnel.*/PermitTunnel no/'                    "$SSH_CONFIG"
sed -i 's/^#AllowAgentForwarding.*/AllowAgentForwarding no/'    "$SSH_CONFIG"
