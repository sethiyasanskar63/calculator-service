package com.calculator.controller;

import com.calculator.domain.CalculationRequest;
import com.calculator.domain.CalculationResponse;
import com.calculator.service.CalculatorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/calculator")
@Tag(name = "Calculator", description = "Calculator API for basic arithmetic operations")
public class CalculatorController {

    private final CalculatorService calculatorService;

    @Autowired
    public CalculatorController(CalculatorService calculatorService) {
        this.calculatorService = calculatorService;
    }

    @PostMapping("/calculate")
    @Operation(
        summary = "Perform arithmetic calculation",
        description = "Performs basic arithmetic operations (addition, subtraction, multiplication, division) on two numbers"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Calculation successful",
            content = @Content(schema = @Schema(implementation = CalculationResponse.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid input or operation",
            content = @Content(schema = @Schema(implementation = CalculationResponse.class))
        )
    })
    public ResponseEntity<CalculationResponse> calculate(
            @Parameter(description = "Calculation request containing two numbers and an operation (+, -, *, /)")
            @Valid @RequestBody CalculationRequest request) {
        try {
            CalculationResponse response = calculatorService.calculate(request);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            CalculationResponse errorResponse = new CalculationResponse();
            errorResponse.setNumber1(request.getNumber1());
            errorResponse.setNumber2(request.getNumber2());
            errorResponse.setOperation(request.getOperation());
            errorResponse.setSuccess(false);
            errorResponse.setMessage(e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        } catch (ArithmeticException e) {
            CalculationResponse errorResponse = new CalculationResponse();
            errorResponse.setNumber1(request.getNumber1());
            errorResponse.setNumber2(request.getNumber2());
            errorResponse.setOperation(request.getOperation());
            errorResponse.setSuccess(false);
            errorResponse.setMessage(e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
        }
    }

    @GetMapping("/health")
    @Operation(
        summary = "Health check endpoint",
        description = "Returns the health status of the calculator service"
    )
    @ApiResponse(
        responseCode = "200",
        description = "Service is healthy and running"
    )
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Calculator service is running!");
    }
}
