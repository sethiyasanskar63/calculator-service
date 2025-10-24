package com.calculator.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

@Schema(description = "Request object for arithmetic calculation")
public class CalculationRequest {
    
    @NotNull(message = "First number is required")
    @Schema(description = "First number in the calculation", example = "10.0", required = true)
    private Double number1;
    
    @NotNull(message = "Second number is required")
    @Schema(description = "Second number in the calculation", example = "5.0", required = true)
    private Double number2;
    
    @NotNull(message = "Operation is required")
    @Schema(description = "Arithmetic operation to perform", example = "+", allowableValues = {"+", "-", "*", "/"}, required = true)
    private String operation;

    public CalculationRequest() {
    }

    public CalculationRequest(Double number1, Double number2, String operation) {
        this.number1 = number1;
        this.number2 = number2;
        this.operation = operation;
    }

    public Double getNumber1() {
        return number1;
    }

    public void setNumber1(Double number1) {
        this.number1 = number1;
    }

    public Double getNumber2() {
        return number2;
    }

    public void setNumber2(Double number2) {
        this.number2 = number2;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }
}
