package com.calculator.domain;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Response object containing calculation result")
public class CalculationResponse {
    
    @Schema(description = "First number used in the calculation", example = "10.0")
    private Double number1;
    
    @Schema(description = "Second number used in the calculation", example = "5.0")
    private Double number2;
    
    @Schema(description = "Operation performed", example = "+")
    private String operation;
    
    @Schema(description = "Result of the calculation", example = "15.0")
    private Double result;
    
    @Schema(description = "Indicates if the calculation was successful", example = "true")
    private boolean success;
    
    @Schema(description = "Message describing the result or error", example = "Calculation successful")
    private String message;

    public CalculationResponse() {
    }

    public CalculationResponse(Double number1, Double number2, String operation, Double result) {
        this.number1 = number1;
        this.number2 = number2;
        this.operation = operation;
        this.result = result;
        this.success = true;
        this.message = "Calculation successful";
    }
    
    public CalculationResponse(Double number1, Double number2, String operation, Double result, boolean success, String message) {
        this.number1 = number1;
        this.number2 = number2;
        this.operation = operation;
        this.result = result;
        this.success = success;
        this.message = message;
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

    public Double getResult() {
        return result;
    }

    public void setResult(Double result) {
        this.result = result;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
