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
