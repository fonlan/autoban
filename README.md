# autoban

autoban is a very simple tool running in Openwrt/Lede which can detect the bad password SSH login attemt and block the source IP by iptables for 24h.
autoban will check system log every 2min by crond job.

*Note: it's only support the default SSH server Dropbear.*