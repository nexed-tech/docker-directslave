# directslave
DirectSlave docker based on Alpine
### Check it out on [directslave.com](https://directslave.com/)

## About (from directslave.com)
This software (DirectSlave) is designed for fast & easy slave DNS management, interacting with DirectAdmin powered servers using DirectAdmin multiserver API. Configuration of master DirectAdmin server is not necessary, software provides DirectAdmin multiserver API emulation via HTTP protocol. You only need to enable Multi Server feature on master DirectAdmin server and set it up to work with DirectSlave. Basic understanding of DNS basics also might be helpful.

## Usage
Here are some example snippets to help you get started creating a container.

### docker compose (recommended)

Without SSL:
```yaml
---
services:
  directslave:
    image: nexed-tech/directslave
    container_name: directslave
    volumes:
      - directslave:/app
    ports:
      - 53:53/udp
      - 53:53/tcp
      - 2222:2222
    restart: unless-stopped

volumes:
  directslave:
```

With SSL:
```yaml
---
services:
  directslave:
    image: nexed-tech/directslave
    container_name: directslave
    environment:
      - SSL=on
      - EMAIL=your@email.com
      - DOMAIN=ns02.yourdomain.com
    volumes:
      - directslave:/app
    ports:
      - 53:53/udp
      - 53:53/tcp
      - 80:80
      - 2224:2224
    restart: unless-stopped

volumes:
  directslave:
```

### docker cli

Without SSL:
```
docker run -d \
  --name=directslave \
  -p 53:53/udp \
  -p 53:53/tcp \
  -p 2222:2222 \
  -v directslave:/app \
  --restart unless-stopped \
  nexed-tech/directslave
```

With SSL:
```
docker run -d \
  --name=directslave \
  -e SSL=on \
  -e EMAIL=your@email.com \
  -e DOMAIN=ns02.yourdomain.com \
  -p 53:53/udp \
  -p 53:53/tcp \
  -p 80:80 \
  -p 2224:2224 \
  -v directslave:/app \
  --restart unless-stopped \
  nexed-tech/directslave
```

## Setup

SSL is optional but recommended. Without SSL, directslave listens on port 2222. With SSL, it listens on port 2224 and port 80 is required for Let's Encrypt certificate issuance.

On first start, an `admin` user is created with a randomly generated password. **Check the container logs for the credentials:**
```
docker logs directslave
```
It is recommended to create a new user and delete the default `admin` account afterwards.

## Parameters

| Parameter | Function |
|-----------|----------|
| `-p 53/udp` | DNS (required) |
| `-p 53/tcp` | DNS over TCP (required) |
| `-p 80` | Required for Let's Encrypt certificate issuance |
| `-p 2222` | DirectSlave web interface (non-SSL) |
| `-p 2224` | DirectSlave web interface (SSL) |
| `-e SSL=on` | Enable SSL using Let's Encrypt |
| `-e EMAIL=your@email.com` | Email address for Let's Encrypt |
| `-e DOMAIN=ns02.yourdomain.com` | Domain to register the SSL certificate for |
| `-v /app` | Persistent storage for slave zones, logs, and credentials |

## Updating

### Via Docker Compose
```
docker compose pull
docker compose up -d
docker image prune
```

### Via Docker Run
```
docker pull nexed-tech/directslave
docker stop directslave
docker rm directslave
```
Recreate the container using the same `docker run` command. Your data in `/app` will be preserved if the volume is mapped correctly.
```
docker image prune
```
