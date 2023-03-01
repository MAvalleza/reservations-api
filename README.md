# Reservations API

Simple API for processing two types of reservation payload and saving them in one endpoint

## Getting Started

### For local development

1. Clone the repository
2. Install the necessary dependencies by running `bundle install`
3. Set up the database by running `rails db:migrate`
4. Start the application by running `rails server`

### Using Docker (RECOMMENDED)

It is **recommended** to use Docker to start the application to avoid any potential problems in dependencies.

1. Clone the repository.

2. To start the Docker application, simply execute the following command while in the project's root folder:

```bash
docker compose up --build -d
```

The application will be visible in the Docker dashboard or by running `docker ps` 

3. Access the container

```bash
docker exec -it reservations-api-web-1 /bin/bash
```

4. Set up the database by running `rake db:migrate`

### Accessing the API

The API will be served at `http://localhost:3000`

## Running tests

Rspec is used as the test suite for the project

Run tests by using this command:

```bash
bundle exec rspec
```

## Running Endpoints

### Payloads

Currently there are 2 types of request payloads that can be processed

Note that both are assigned to a `data` attribute in the request payload for `ActionController::StrongParameters` usage purposes.

#### Payload #1

```json
{
    "data": {
        "reservation_code": "YYY12345678",
        "start_date": "2021-04-14",
        "end_date": "2021-04-18",
        "nights": 4,
        "guests": 4,
        "adults": 2,
        "children": 2,
        "infants": 0,
        "status": "accepted",
        "guest": {
            "first_name": "Wayne",
            "last_name": "Woodbridge",
            "phone": "639123456789",
            "email": "wayne_woodbridge@bnb.com"
        },
        "currency": "AUD",
        "payout_price": "4200.00",
        "security_price": "500",
        "total_price": "4700.00"
    }
}
```

#### Payload #2

```json
{
    "data": {
        "reservation": {
            "code": "XXX12345678",
            "start_date": "2021-03-12",
            "end_date": "2021-03-16",
            "expected_payout_amount": "3800.00",
            "guest_details": {
                "localized_description": "4 guests",
                "number_of_adults": 2,
                "number_of_children": 2,
                "number_of_infants": 0
                },
            "guest_email": "wayne_woodbridge@bnb.com",
            "guest_first_name": "Wayne",
            "guest_last_name": "Woodbridge",
            "guest_phone_numbers": [
                "639123456789",
                "639123456789"
            ],
            "listing_security_price_accurate": "500.00",
            "host_currency": "AUD",
            "nights": 4,
            "number_of_guests": 4,
            "status_type": "accepted",
            "total_paid_amount_accurate": "4300.00"
        }
    }
}

```

### Endpoints

The following endpoints are available:

Main Endpoints (for the exercise)

* `POST /api/v1/reservations` - for saving and processing the two types of payloads
* `PUT /api/v1/reservations/:code` - used for updating reservation details (also accepts the two types of payload)

Additional endpoints are added for listing reservations and guests for easy viewing of created data

### Running in Postman

It is recommended to use Postman in running the endpoints.

A Postman collection is prepared along with some examples

[![Run in Postman](https://run.pstmn.io/button.svg)](https://god.gw.postman.com/run-collection/26130614-07f7a2c4-9fff-4178-931f-3369b98782b3?action=collection%2Ffork&collection-url=entityId%3D26130614-07f7a2c4-9fff-4178-931f-3369b98782b3%26entityType%3Dcollection%26workspaceId%3D35170105-0964-46e7-a4d4-52b36d03e60b)
