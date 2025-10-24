package com.calculator.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
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
}
