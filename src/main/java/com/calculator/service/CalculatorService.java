package com.calculator.service;

import com.calculator.domain.CalculationRequest;
import com.calculator.domain.CalculationResponse;
import org.springframework.stereotype.Service;

@Service
public class CalculatorService {

    public CalculationResponse calculate(CalculationRequest request) {
        Double number1 = request.getNumber1();
        Double number2 = request.getNumber2();
        String operation = request.getOperation();
        
        Double result;
        
        switch (operation) {
            case "+":
                result = add(number1, number2);
                break;
            case "-":
                result = subtract(number1, number2);
                break;
            case "*":
                result = multiply(number1, number2);
                break;
            case "/":
                result = divide(number1, number2);
                break;
            default:
                throw new IllegalArgumentException("Invalid operation: " + operation + ". Supported operations: +, -, *, /");
        }
        
        return new CalculationResponse(number1, number2, operation, result);
    }
    
    private Double add(Double a, Double b) {
        return a + b;
    }
    
    private Double subtract(Double a, Double b) {
        return a - b;
    }
    
    private Double multiply(Double a, Double b) {
        return a * b;
    }
    
    private Double divide(Double a, Double b) {
        if (b == 0) {
            throw new ArithmeticException("Division by zero is not allowed");
        }
        return a / b;
    }
}
