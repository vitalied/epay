![build](https://github.com/vitalied/epay/workflows/build/badge.svg)

# ePay

## Setup

### Build app image
```
docker-compose build
```

### Database
#### Run mysql and redis
```
docker-compose up -d mysql redis
```

#### Prepare DB
##### Create database, run migrations and add seed entries.
```
docker-compose run epay bundle exec rails db:setup
```

## Run app
```
docker-compose up
```

## Run tests
```
docker-compose run epay bundle exec rspec
```

## Access app

#### URL
http://localhost:3000

#### Demo credentials
##### Admin
```
email: admin@dev.local
password: 123456
```

##### Merchant
```
email: merchant1@dev.local
password: 123456
```

## Transactions API
#### Method and URL
```
POST http://localhost:3000/api/transactions
```

#### Headers
```
Accept application/json
Content-Type application/json
Authorization Token token_hash
```
#### Body
```
{
  "type": "authorize",
  "reference_uuid": null,
  "uuid": "b6b89388-0aa6-4488-a124-7159679a873d",
  "amount": 9.99,
  "status": "approved",
  "customer_email": "customer1@dev.local",
  "customer_phone": "+5551111111"
}
```

#### Demo tokens
##### Active merchant
```
Authorization Token 123456
```

##### Inactive merchant
```
Authorization Token 654321
```

## Import data from CSV
##### Replace `import/admins.csv` and `import/merchants.csv` files with real data

#### Import admins
```
docker-compose run epay bundle exec rails import:admins
```

#### Import merchants
```
docker-compose run epay bundle exec rails import:merchants
```
