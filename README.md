# Calculator Microservice

A simple Spring Boot microservice that performs basic arithmetic operations (+, -, *, /) for learning CI/CD.

## Features

- RESTful API for calculations
- Domain-driven design with request/response models
- Service layer with business logic
- Comprehensive unit tests
- Input validation
- Error handling

## Project Structure

```
src/
├── main/
│   ├── java/com/calculator/
│   │   ├── CalculatorApplication.java       # Main Spring Boot application
│   │   ├── controller/
│   │   │   └── CalculatorController.java    # REST controller
│   │   ├── service/
│   │   │   └── CalculatorService.java       # Business logic
│   │   └── domain/
│   │       ├── CalculationRequest.java      # Request DTO
│   │       └── CalculationResponse.java     # Response DTO
│   └── resources/
│       └── application.properties            # Application configuration
└── test/
    └── java/com/calculator/
        ├── service/
        │   └── CalculatorServiceTest.java    # Service unit tests
        └── controller/
            └── CalculatorControllerTest.java # Controller tests
```

## API Endpoints

### Health Check
```
GET /api/calculator/health
```

### Calculate
```
POST /api/calculator/calculate
Content-Type: application/json

{
  "number1": 10.0,
  "number2": 5.0,
  "operation": "+"
}
```

**Supported Operations:** `+`, `-`, `*`, `/`

**Response:**
```json
{
  "number1": 10.0,
  "number2": 5.0,
  "operation": "+",
  "result": 15.0,
  "success": true,
  "message": "Calculation successful"
}
```

## Running the Application

### Prerequisites
- Java 17 or higher
- Maven 3.6+

### Build and Run

```bash
# Build the project
mvn clean install

# Run the application
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

### Run Tests

```bash
# Run all tests
mvn test

# Run tests with coverage
mvn test jacoco:report
```

## Testing with cURL

```bash
# Health check
curl http://localhost:8080/api/calculator/health

# Addition
curl -X POST http://localhost:8080/api/calculator/calculate \
  -H "Content-Type: application/json" \
  -d "{\"number1\": 10, \"number2\": 5, \"operation\": \"+\"}"

# Subtraction
curl -X POST http://localhost:8080/api/calculator/calculate \
  -H "Content-Type: application/json" \
  -d "{\"number1\": 10, \"number2\": 5, \"operation\": \"-\"}"

# Multiplication
curl -X POST http://localhost:8080/api/calculator/calculate \
  -H "Content-Type: application/json" \
  -d "{\"number1\": 10, \"number2\": 5, \"operation\": \"*\"}"

# Division
curl -X POST http://localhost:8080/api/calculator/calculate \
  -H "Content-Type: application/json" \
  -d "{\"number1\": 10, \"number2\": 5, \"operation\": \"/\"}"
```

## CI/CD Ready

This microservice is designed for CI/CD learning and includes:
- Maven build configuration
- Unit and integration tests
- Clean architecture
- Docker-ready structure

Next steps for CI/CD:
1. Add Dockerfile
2. Setup GitHub Actions / Jenkins pipeline
3. Add code quality checks (SonarQube)
4. Configure deployment to Kubernetes/Cloud
