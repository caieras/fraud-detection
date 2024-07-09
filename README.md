# Fraud Detection API

This project is a Sinatra-based API for fraud detection. It uses PostgreSQL as the database and Redis for caching and background job processing.

## Architecture
### MVC Pattern with Sinatra

We chose MVC for this Sinatra app primarily for its simplicity and familiarity within the Ruby community. 

While Clean Architecture offers more rigorous separation of concerns, MVC provides a good balance of structure and flexibility that aligns well with Sinatra's nature and the project's scope.

- **Models**: Located in `lib/models/`, we use Sequel for database interactions. Models represent our data structures and business logic.
- **Views**: As an API, we don't have traditional views, but our JSON responses can be considered as our view layer.
- **Controllers**: Found in `lib/controllers/`, these handle incoming requests, interact with models and services, and send responses.

Sinatra acts as our router, directing requests to the appropriate controllers.

### Database and Caching

- **PostgreSQL**: Our primary datastore, used for persistent storage of all application data.
- **Redis**: Used for caching and fast read operations.
- **Redis Objects**: We utilize the `redis-objects` gem to synchronize our database-persistent models with Redis. This allows for extremely fast read operations on frequently accessed data.

### Performance Optimization

- **Connection Pooling**: Implemented for both PostgreSQL and Redis to manage connections efficiently.
- **Background Jobs**: Sidekiq is used for processing background jobs, allowing the API to respond quickly while offloading time-consuming tasks.

### Security Features

- **Rack Attack**: Implemented to protect against abusive requests. This can be further customized to add rate limiting specific to our API's needs.
- **Encrypted Tables**: Sensitive data, such as credit card information, is stored in encrypted database tables to ensure data protection at rest.
- **Environment Variables**: Sensitive configuration is stored in environment variables, not in the codebase.

### Testing

- **RSpec**: Used for unit and integration testing.
- **Rubocop**: Ensures code style consistency across the project.

### Deployment

- **Docker**: The application is containerized, allowing for easy deployment and scaling.
- **Docker Compose**: Used for defining and running multi-container Docker applications, simplifying the development and deployment process.



## Prerequisites

- Ruby (version specified in `.ruby-version` or Gemfile)
- PostgreSQL
- Redis

## Installation

1. Clone the repository:
```
git clone 
```
2. Install dependencies:
```
bundle install
```
3. Set up the database:
```
$ psql -d postgres -f db/init.sql
```
4. Set up environment variables:
```
- Update `.env` with your configuration
```

## Running the Application

### Locally

1. Start Redis:
```
redis-server
```
2. Start the Sinatra server:
```
rackup
```

## Running with Docker

1. Just run: 
```
docker-compose up
```

## Example payload
```json
{
  "transaction_id" : 123,
  "merchant_id" : 29744,
  "user_id" : 97051,
  "card_number" : "434505******9116",
  "transaction_date" : "2024-11-31T23:16:32.812632",
  "transaction_amount" : 373,
  "device_id" : 285475
}
```
## Example response
```json
{ 
  "transaction_id" : 123,
  "recommendation" : "approve"
}
```
