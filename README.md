# 🏨 Booking Oselya — Infrastructure

Production infrastructure for the **Booking Oselya** hotel booking platform.
Manages Docker orchestration, CI/CD, monitoring, security, and automated backups.

[![Production](https://img.shields.io/badge/production-live-success)](https://booking-oselya.pp.ua)
[![Security](https://img.shields.io/badge/security-90%2F100-blue)](#security)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## 🏗️ Architecture

```
Internet
    │
    ▼
Cloudflare (DNS + SSL/TLS + WAF + DDoS Protection)
    │
    ▼
AWS EC2 (Ubuntu 24.04, eu-central-1)
    │
    ▼
Nginx (Reverse Proxy / API Gateway)
    │
    ├── /api/User        → User API        (C# .NET 8)
    ├── /api/Offer       → Offer API       (C# .NET 8)
    ├── /api/Order       → Order API       (C# .NET 8)
    ├── /api/City        → Location API    (C# .NET 8)
    ├── /api/Attraction  → Attraction API  (C# .NET 8)
    ├── /api/RentObj     → RentObject API  (C# .NET 8)
    ├── /api/Review      → Review API      (C# .NET 8)
    ├── /api/Statistic   → Statistic API   (C# .NET 8)
    ├── /api/Translation → Translation API (C# .NET 8)
    └── /               → Frontend        (React)

Shared Infrastructure:
    ├── PostgreSQL 15    (9 separate databases)
    ├── RabbitMQ 3.12   (message broker)
    └── Monitoring Server (Prometheus + Grafana)
```

---

## 🚀 Services

| Service | Container | Description |
|---------|-----------|-------------|
| **Nginx** | booking_nginx | API Gateway & reverse proxy |
| **User API** | booking_user_api | Authentication & user management |
| **Offer API** | booking_offer_api | Hotel offers & availability |
| **Order API** | booking_order_api | Booking & order processing |
| **Location API** | booking_location_api | Cities, regions, districts |
| **Attraction API** | booking_attraction_api | Tourist attractions |
| **RentObject API** | booking_rentobject_api | Rental properties |
| **Review API** | booking_review_api | User reviews & ratings |
| **Statistic API** | booking_statistic_api | Analytics & statistics |
| **Translation API** | booking_translation_api | i18n (UA/EN/RU) |
| **Frontend** | booking_frontend | React web application |
| **PostgreSQL** | booking_postgres | Primary database (9 DBs) |
| **RabbitMQ** | booking_rabbitmq | Message broker |
| **Prometheus** | — | Metrics collection (monitoring server) |
| **Grafana** | — | Dashboards & alerting (monitoring server) |
| **Telegram Bot** | booking_telegram_bot | CI/CD & monitoring notifications |

---

## 🔒 Security

| Layer | Technology | Status |
|-------|-----------|--------|
| SSL/TLS | Cloudflare (Full Strict) | ✅ Active |
| WAF | Cloudflare WAF (6 rules) | ✅ Active |
| DDoS Protection | Cloudflare (all layers) | ✅ Active |
| Brute-force Protection | Fail2Ban | ✅ Active |
| Security Headers | Nginx (HSTS, CSP, X-Frame) | ✅ Active |
| Vulnerability Scanning | Trivy (in CI/CD) | ✅ Active |
| Penetration Testing | OWASP ZAP | ✅ 0 critical issues |

**Cloudflare WAF Rules:**
- Block SQL Injection
- Block XSS
- Block Path Traversal
- Block Config Scanners
- Block Bad Bots
- Basic Rate Limiting

---

## 📊 Monitoring

| Tool | URL | Purpose |
|------|-----|---------|
| Grafana | http://monitoring-server:3000 | Dashboards & alerts |
| Prometheus | http://monitoring-server:9090 | Metrics |
| RabbitMQ UI | http://server:15672 | Queue management |
| Node Exporter | :9100 | System metrics |
| cAdvisor | :9323 | Container metrics |
| Postgres Exporter | :9187 | Database metrics |
| Nginx Exporter | :9113 | Web server metrics |

---

## 💾 Automated Backups

All 7 PostgreSQL databases are backed up automatically every night at 02:00:

```
booking_db, booking_translations, booking_locations,
booking_attractions, booking_rentobjects, booking_reviews, booking_statistics
```

- **Schedule:** Daily at 02:00 (cron)
- **Retention:** 7 days (older backups deleted automatically)
- **Format:** gzip compressed SQL dumps
- **Location:** `~/Booking-infrastructure/backups/`

Manual backup:
```bash
bash ~/Booking-infrastructure/backups/backup.sh
```

---

## 🔄 CI/CD Pipeline

### Backend (GitHub Actions)
- **Trigger:** Push to `main` or `devops/frontend-deployment` with changes in `backend/`
- **Steps:** Build → Push to DockerHub → Deploy to EC2
- **Images:** `spartakj/booking-{service-name}:latest`
- **Matrix build:** All 10 services in parallel

### Frontend (GitHub Actions)
- **Trigger:** Push with changes in `frontend/`
- **Steps:** Build → Security scan (Trivy) → Push to DockerHub → Deploy

### Notifications
All CI/CD events are reported to **Telegram** via the booking bot.

---

## 🛠️ Quick Start (Local Development)

### Prerequisites
- Docker Desktop
- Docker Compose v2.x
- Git

### 1. Clone repositories
```bash
git clone https://github.com/Spartak-J/Booking-infrastructure.git
git clone https://github.com/Spartak-J/Booking-app.git
```

### 2. Configure environment
```bash
cd Booking-infrastructure
# Edit .env with your credentials
```

### 3. Start all services
```bash
docker compose up -d
```

### 4. Check status
```bash
docker compose ps
docker ps --format "table {{.Names}}\t{{.Status}}"
```

---

## 📁 Repository Structure

```
Booking-infrastructure/
├── docker-compose.yml              # Main orchestration (all services)
├── docker-compose.frontend.yml     # Frontend only
├── docker-compose.telegram.yml     # Telegram bot
├── docker-compose.security.yml     # Security tools
├── nginx/
│   ├── nginx.conf                  # Main Nginx config
│   └── conf.d/
│       ├── api-gateway.conf        # API routing & security headers
│       ├── proxy_params.conf       # Proxy parameters
│       └── stub_status.conf        # Nginx metrics
├── backups/
│   └── backup.sh                   # PostgreSQL backup script
└── README.md
```

---

## 👥 Team

| Role | Responsibility |
|------|---------------|
| **Artem** (DevOps) | Infrastructure, Docker, CI/CD, Security, Monitoring |
| **Yuliia** (Backend) | C# .NET APIs, PostgreSQL, RabbitMQ |
| **Inna** (Frontend) | React web app, React Native mobile |

---

## 🔗 Links

- **Production:** https://booking-oselya.pp.ua
- **Application Repository:** https://github.com/Spartak-J/Booking-app
- **Documentation:** https://github.com/Spartak-J/Booking-docs
