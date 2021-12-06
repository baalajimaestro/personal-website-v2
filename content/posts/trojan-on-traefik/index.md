---
title: "Hosting Trojan-GFW with Traefik"
date: 2021-12-04T21:24:00+05:30
---

For those who don't know what trojan-gfw is, please google up.

I searched far and wide on the internet, but there isn't any proper document or article that guided me to it.

I managed to self-host it, so I'll share the steps with you.

### What you need:
- Traefik (obviously)
- A domain (obviously)
- Certbot installed on the host
- A snakeoil caddy server (preferably some valid server)

Let's get started,

Connect to your server over SSH and then let's issue a certificate for the trojan to work
Change the domain name to whatever your VPN would be hosted on

```
sudo certbot certonly \
  --standalone \
  -m baalajimaestro@computer4u.com \
  -d something.baalajimaestro.me
```

Once you get the certificate issued, let's start off working on the config for trojan-go

```
{
  "run_type": "server",
  "local_addr": "0.0.0.0",
  "local_port": 443,
  "remote_addr": "trojan-caddy",
  "remote_port": 80,
  "log_level": 2,
  "log_file": "",
  "password": [
    "somethingsupersecret"
  ],
  "disable_http_check": false,
  "udp_timeout": 60,
  "ssl": {
    "verify": true,
    "verify_hostname": true,
    "cert": "/etc/trojan/cert.pem",
    "key": "/etc/trojan/private.key",
    "key_password": "",
    "cipher": "",
    "curves": "",
    "prefer_server_cipher": false,
    "sni": "something.baalajimaestro.me",
    "alpn": [
      "http/1.1"
    ],
    "session_ticket": true,
    "reuse_session": true,
    "plain_http_response": "",
    "fallback_addr": "",
    "fallback_port": 0,
    "fingerprint": "firefox"
  },
  "tcp": {
    "no_delay": true,
    "keep_alive": true,
    "prefer_ipv4": true
  },
  "router": {
    "enabled": false,
    "bypass": [],
    "proxy": [],
    "block": [],
    "default_policy": "proxy",
    "domain_strategy": "as_is",
    "geoip": "$PROGRAM_DIR$/geoip.dat",
    "geosite": "$PROGRAM_DIR$/geosite.dat"
  },
  "websocket": {
    "enabled": true,
    "path": "/socketplug",
    "host": "something.baalajimaestro.me"
  },
  "shadowsocks": {
    "enabled": false,
    "method": "AES-128-GCM",
    "password": ""
  },
  "transport_plugin": {
    "enabled": false,
    "type": "",
    "command": "",
    "plugin_option": "",
    "arg": [],
    "env": []
  },
  "forward_proxy": {
    "enabled": false,
    "proxy_addr": "",
    "proxy_port": 0,
    "username": "",
    "password": ""
  },
  "mysql": {
    "enabled": false,
    "server_addr": "localhost",
    "server_port": 3306,
    "database": "",
    "username": "",
    "password": "",
    "check_rate": 60
  },
  "api": {
    "enabled": false,
    "api_addr": "",
    "api_port": 0,
    "ssl": {
      "enabled": false,
      "key": "",
      "cert": "",
      "verify_client": false,
      "client_cert": []
    }
  }
}
```

### What changes do you need?

- The password field, generate a pretty strong password that someone cannot guess.
- sni and WebSocket host, to whatever domain you chose earlier

The rest of the configuration should be fine, if you need to tweak anything feel free to look into trojan-gfw docs.

Spin up a snakeoil caddyserver so that trojan can proxy to it whenever it detects non-trojan traffic.

```
docker run -d --restart unless-stopped \
              --name trojan-caddy \
              --network docker-network \
              caddy:alpine
```

Now, for trojan itself, check to see the paths for the certificate, and the config and your HostSNI is edited properly to match your domain.

```
docker run -d --restart unless-stopped \
              --name trojan-go \
              --network docker-network \
              -v /home/baalajimaestro/dockerhome/trojan/config.json:/etc/trojan/config.json \
              -v /etc/letsencrypt/live/something.baalajimaestro.me/fullchain.pem:/etc/trojan/cert.pem \
              -v /etc/letsencrypt/live/something.baalajimaestro.me/privkey.pem:/etc/trojan/private.key \
              -l traefik.enable=true \
              -l traefik.tcp.routers.trojan-gfw.rule='HostSNI(`something.baalajimaestro.me`)' \
              -l traefik.tcp.routers.trojan-gfw.tls.passthrough="true" \
              -l traefik.tcp.services.trojan-gfw.loadbalancer.server.port="443" \
              p4gefau1t/trojan-go /etc/trojan/config.json
```

Now if you visit something.baalajimaestro.me, you should see Caddy's welcome page.
Ensure you point it to rather some valid page instead of the congratulations page of caddy, so that your ISP doesn't grow sus of you transferring a huge amount of data to a "Congratulations" page.

### How does this work?

We are doing a TLS passthrough on traefik so that it lets trojan handle the TLS itself for the proxy domain.

### Places to improve:

- Put it behind a CDN (I used Cloudflare), so that the connection latency improves much better and someone doesn't get your server IP.
