# Docker Laravel

Docker image for Laravel framework with Alpine Linux

- Alpine 3.13.5
- Nginx
- PHP 8

## Usage

```
docker build -t laravel-alpine:1.0 . --no-cache
docker run --rm -p 3030:80 --name laravel-alpine laravel-alpine:1.0
```

See on http://localhost:3030
