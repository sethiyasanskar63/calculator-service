package com.calculator.controller;

import com.calculator.domain.CalculationRequest;
import com.calculator.domain.CalculationResponse;
import com.calculator.service.CalculatorService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(CalculatorController.class)
class CalculatorControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private CalculatorService calculatorService;

    @Test
    @DisplayName("Should return 200 OK for health endpoint")
    void testHealthEndpoint() throws Exception {
        mockMvc.perform(get("/api/calculator/health"))
                .andExpect(status().isOk())
                .andExpect(content().string("Calculator service is running!"));
    }

    @Test
    @DisplayName("Should calculate addition successfully")
    void testCalculateAddition() throws Exception {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 5.0, "+");
        CalculationResponse mockResponse = new CalculationResponse(10.0, 5.0, "+", 15.0);
        
        when(calculatorService.calculate(any(CalculationRequest.class)))
                .thenReturn(mockResponse);
        
        // Act & Assert
        mockMvc.perform(post("/api/calculator/calculate")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.result").value(15.0))
                .andExpect(jsonPath("$.number1").value(10.0))
                .andExpect(jsonPath("$.number2").value(5.0))
                .andExpect(jsonPath("$.operation").value("+"))
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("Should return 400 for division by zero")
    void testDivisionByZero() throws Exception {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 0.0, "/");
        
        when(calculatorService.calculate(any(CalculationRequest.class)))
                .thenThrow(new ArithmeticException("Division by zero is not allowed"));
        
        // Act & Assert
        mockMvc.perform(post("/api/calculator/calculate")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.message").value("Division by zero is not allowed"));
    }

    @Test
    @DisplayName("Should return 400 for invalid operation")
    void testInvalidOperation() throws Exception {
        // Arrange
        CalculationRequest request = new CalculationRequest(10.0, 5.0, "%");
        
        when(calculatorService.calculate(any(CalculationRequest.class)))
                .thenThrow(new IllegalArgumentException("Invalid operation: %. Supported operations: +, -, *, /"));
        
        // Act & Assert
        mockMvc.perform(post("/api/calculator/calculate")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("Should return 400 when number1 is null")
    void testValidationNumber1Null() throws Exception {
        // Arrange
        String invalidRequest = "{\"number2\": 5.0, \"operation\": \"+\"}";
        
        // Act & Assert
        mockMvc.perform(post("/api/calculator/calculate")
                .contentType(MediaType.APPLICATION_JSON)
                .content(invalidRequest))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("Should calculate subtraction successfully")
    void testCalculateSubtraction() throws Exception {
        // Arrange
        CalculationRequest request = new CalculationRequest(20.0, 8.0, "-");
        CalculationResponse mockResponse = new CalculationResponse(20.0, 8.0, "-", 12.0);
        
        when(calculatorService.calculate(any(CalculationRequest.class)))
                .thenReturn(mockResponse);
        
        // Act & Assert
        mockMvc.perform(post("/api/calculator/calculate")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.result").value(12.0))
                .andExpect(jsonPath("$.operation").value("-"));
    }
}
