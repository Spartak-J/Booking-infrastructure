# ���️ Booking Oselya - Infrastructure

Infrastructure and deployment configuration for Booking Oselya hotel booking system.

## ���️ Architecture
```
┌─────────────────────────────────────────────┐
│           Booking Oselya System              │
├─────────────────────────────────────────────┤
│  ┌────────────┐  ┌────────────┐  ┌────────┐│
│  │ User API   │  │ Offer API  │  │Order API││
│  │  (5001)    │  │  (5002)    │  │ (5003) ││
│  └─────┬──────┘  └─────┬──────┘  └────┬───┘│
│        │                │               │    │
│  ┌─────┴────────────────┴───────────────┴──┐│
│  │         RabbitMQ Message Broker          ││
│  │              (5672, 15672)               ││
│  └──────────────────────────────────────────┘│
│  ┌──────────────────────────────────────────┐│
│  │      PostgreSQL Database (5432)          ││
│  └──────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

## ��� Quick Start

### Prerequisites
- Docker Desktop installed
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
cp .env.example .env
# Edit .env with your passwords
```

### 3. Start all services
```bash
docker-compose up -d --build
```

### 4. Check status
```bash
docker-compose ps
```

### 5. Test APIs
```bash
curl http://localhost:5001/weatherforecast  # User API
curl http://localhost:5002/weatherforecast  # Offer API
curl http://localhost:5003/weatherforecast  # Order API
```

## ��� Services

| Service | Port | Description |
|---------|------|-------------|
| **user-api** | 5001 | User management & authentication |
| **offer-api** | 5002 | Hotel offers & bookings |
| **order-api** | 5003 | Order processing |
| **postgres** | 5432 | PostgreSQL database |
| **rabbitmq** | 5672 | AMQP message broker |
| **rabbitmq-mgmt** | 15672 | RabbitMQ Management UI |

## ��� Configuration

### Environment Variables
```env
DB_USER=booking_admin
DB_PASSWORD=your_password
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest
```

### RabbitMQ Management UI

Access: http://localhost:15672
- Username: `guest`
- Password: `guest`

## ���️ Development

### Build services
```bash
docker-compose build
```

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f user-api
```

### Stop services
```bash
docker-compose stop
```

### Remove everything
```bash
docker-compose down -v
```

## ��� Project Structure
```
Booking-infrastructure/
├── docker-compose.yml      # Main orchestration file
├── .env.example            # Environment template
├── .gitignore             # Git ignore rules
└── README.md              # This file

../Booking-app/backend/
├── .dockerignore          # Docker ignore rules
└── booking/
    ├── UserApiService/
    │   └── Dockerfile
    ├── OfferApiService/
    │   └── Dockerfile
    └── OrderApiService/
        └── Dockerfile
```

## ��� Troubleshooting

### Services not starting
```bash
# Check logs
docker-compose logs

# Restart specific service
docker-compose restart user-api
```

### Port conflicts
```bash
# Check what's using the port
netstat -ano | findstr :5001

# Change port in docker-compose.yml
```

### Database connection issues
```bash
# Check postgres is healthy
docker-compose ps postgres

# Connect to database
docker-compose exec postgres psql -U booking_admin -d booking_db
```

## ��� Team

- **DevOps Engineer**: Artem (Infrastructure, Docker, CI/CD)
- **Backend Developer**: Yuliia (C# .NET APIs)
- **Frontend Developer**: Inneta (React, React Native)

## ��� License

MIT License - see LICENSE file

## ��� Links

- **Main Repository**: https://github.com/Spartak-J/Booking-app
- **Infrastructure**: https://github.com/Spartak-J/Booking-infrastructure
- **Production**: https://booking-oselya.pp.ua
