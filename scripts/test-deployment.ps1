# Test your deployed Calculator Service
$baseUrl = "https://calculator-service-production.up.railway.app"

Write-Host "`n🧪 Testing Deployed Calculator Service`n" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Test 1: Health Check
Write-Host "Test 1: Health Check..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "$baseUrl/api/calculator/health" -Method GET
    Write-Host "✅ PASSED: $health`n" -ForegroundColor Green
} catch {
    Write-Host "❌ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Test 2: Addition
Write-Host "Test 2: Addition (10 + 5)..." -ForegroundColor Yellow
try {
    $body = @{
        number1 = 10
        number2 = 5
        operation = "+"
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri "$baseUrl/api/calculator/calculate" -Method POST -Body $body -ContentType "application/json"
    Write-Host "✅ PASSED: $($result.number1) + $($result.number2) = $($result.result)" -ForegroundColor Green
    Write-Host "   Full Response: $($result | ConvertTo-Json -Compress)`n" -ForegroundColor Gray
} catch {
    Write-Host "❌ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Test 3: Multiplication
Write-Host "Test 3: Multiplication (7 * 3)..." -ForegroundColor Yellow
try {
    $body = @{
        number1 = 7
        number2 = 3
        operation = "*"
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri "$baseUrl/api/calculator/calculate" -Method POST -Body $body -ContentType "application/json"
    Write-Host "✅ PASSED: $($result.number1) × $($result.number2) = $($result.result)" -ForegroundColor Green
    Write-Host "   Full Response: $($result | ConvertTo-Json -Compress)`n" -ForegroundColor Gray
} catch {
    Write-Host "❌ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Test 4: Division
Write-Host "Test 4: Division (20 / 4)..." -ForegroundColor Yellow
try {
    $body = @{
        number1 = 20
        number2 = 4
        operation = "/"
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri "$baseUrl/api/calculator/calculate" -Method POST -Body $body -ContentType "application/json"
    Write-Host "✅ PASSED: $($result.number1) ÷ $($result.number2) = $($result.result)" -ForegroundColor Green
    Write-Host "   Full Response: $($result | ConvertTo-Json -Compress)`n" -ForegroundColor Gray
} catch {
    Write-Host "❌ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Test 5: Subtraction
Write-Host "Test 5: Subtraction (15 - 8)..." -ForegroundColor Yellow
try {
    $body = @{
        number1 = 15
        number2 = 8
        operation = "-"
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri "$baseUrl/api/calculator/calculate" -Method POST -Body $body -ContentType "application/json"
    Write-Host "✅ PASSED: $($result.number1) - $($result.number2) = $($result.result)" -ForegroundColor Green
    Write-Host "   Full Response: $($result | ConvertTo-Json -Compress)`n" -ForegroundColor Gray
} catch {
    Write-Host "❌ FAILED: $($_.Exception.Message)`n" -ForegroundColor Red
}

Write-Host "========================================`n" -ForegroundColor Cyan
Write-Host "Interactive Testing:" -ForegroundColor Cyan
Write-Host "   Swagger UI: $baseUrl/swagger-ui.html`n" -ForegroundColor White
Write-Host "API Endpoints:" -ForegroundColor Cyan
Write-Host "   Health: GET  $baseUrl/api/calculator/health" -ForegroundColor White
Write-Host "   Calculate: POST $baseUrl/api/calculator/calculate" -ForegroundColor White
