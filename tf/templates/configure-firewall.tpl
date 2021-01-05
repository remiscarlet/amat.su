[Unit]
Description=Configure firewall for amatsu

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT
ExecStart=/sbin/iptables -A INPUT -p tcp --dport 443 -j ACCEPT

[Install]
WantedBy=multi-user.target
