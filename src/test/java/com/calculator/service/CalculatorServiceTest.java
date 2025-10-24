package com.calculator.service;

import com.calculator.domain.CalculationRequest;
import com.calculator.domain.CalculationResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.junit.jupiter.api.Assertions.*;

class CalculatorServiceTest {

    private CalculatorService calculatorService;

    @BeforeEach
    void setUp() {
        calculatorService = new CalculatorService();
    }

    @Test
    @DisplayName("Should add two numbers correctly")
    void testAddition() {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 5.0, "+");
        
        // Act
        CalculationResponse response = calculatorService.calculate(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(15.0, response.getResult());
        assertEquals(10.0, response.getNumber1());
        assertEquals(5.0, response.getNumber2());
        assertEquals("+", response.getOperation());
        assertTrue(response.isSuccess());
    }

    @Test
    @DisplayName("Should subtract two numbers correctly")
    void testSubtraction() {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 5.0, "-");
        
        // Act
        CalculationResponse response = calculatorService.calculate(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(5.0, response.getResult());
        assertEquals("-", response.getOperation());
        assertTrue(response.isSuccess());
    }

    @Test
    @DisplayName("Should multiply two numbers correctly")
    void testMultiplication() {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 5.0, "*");
        
        // Act
        CalculationResponse response = calculatorService.calculate(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(50.0, response.getResult());
        assertEquals("*", response.getOperation());
        assertTrue(response.isSuccess());
    }

    @Test
    @DisplayName("Should divide two numbers correctly")
    void testDivision() {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 5.0, "/");
        
        // Act
        CalculationResponse response = calculatorService.calculate(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(2.0, response.getResult());
        assertEquals("/", response.getOperation());
        assertTrue(response.isSuccess());
    }

    @Test
    @DisplayName("Should throw ArithmeticException when dividing by zero")
    void testDivisionByZero() {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 0.0, "/");
        
        // Act & Assert
        ArithmeticException exception = assertThrows(
            ArithmeticException.class,
            () -> calculatorService.calculate(request)
        );
        
        assertEquals("Division by zero is not allowed", exception.getMessage());
    }

    @Test
    @DisplayName("Should throw IllegalArgumentException for invalid operation")
    void testInvalidOperation() {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 5.0, "%");
        
        // Act & Assert
        IllegalArgumentException exception = assertThrows(
            IllegalArgumentException.class,
            () -> calculatorService.calculate(request)
        );
        
        assertTrue(exception.getMessage().contains("Invalid operation"));
    }

    @Test
    @DisplayName("Should handle negative numbers in addition")
    void testAdditionWithNegativeNumbers() {
        // Arrange
        CalculationRequest request = new CalculationRequest(-10.0, -5.0, "+");
        
        // Act
        CalculationResponse response = calculatorService.calculate(request);
        
        // Assert
        assertEquals(-15.0, response.getResult());
    }

    @Test
    @DisplayName("Should handle decimal numbers in multiplication")
    void testMultiplicationWithDecimals() {
        // Arrange
        CalculationRequest request = new CalculationRequest(2.5, 4.0, "*");
        
        // Act
        CalculationResponse response = calculatorService.calculate(request);
        
        // Assert
        assertEquals(10.0, response.getResult());
    }
}
