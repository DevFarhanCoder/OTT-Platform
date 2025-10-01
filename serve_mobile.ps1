# Flutter OTT Platform - Mobile Web Server
# PowerShell Script to serve the app on mobile

Write-Host "========================================" -ForegroundColor Green
Write-Host "Flutter OTT Platform - Mobile Web Server" -ForegroundColor Green  
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Get computer's IP address
$IP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.PrefixOrigin -eq "Dhcp"}).IPAddress | Select-Object -First 1

if (-not $IP) {
    $IP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like "192.168.*" -or $_.IPAddress -like "10.*" -or $_.IPAddress -like "172.*"}).IPAddress | Select-Object -First 1
}

Write-Host "🚀 Starting web server for mobile access..." -ForegroundColor Cyan
Write-Host ""
Write-Host "📱 Your OTT Platform will be available at:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   http://$IP`:8080" -ForegroundColor White -BackgroundColor Blue
Write-Host ""
Write-Host "💡 Open this URL in your phone's browser" -ForegroundColor Green
Write-Host "   (Make sure your phone is on the same WiFi network)" -ForegroundColor Gray
Write-Host ""
Write-Host "⏹️  Press Ctrl+C to stop the server" -ForegroundColor Red
Write-Host ""

# Navigate to web build directory
Set-Location "build\web"

# Try to start a simple HTTP server using PowerShell
try {
    # Check if Python is available
    $pythonInstalled = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonInstalled) {
        Write-Host "✅ Using Python HTTP server..." -ForegroundColor Green
        python -m http.server 8080
    } else {
        # Use PowerShell's built-in web server capabilities
        Write-Host "✅ Using PowerShell HTTP server..." -ForegroundColor Green
        
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add("http://*:8080/")
        $listener.Start()
        
        Write-Host "🌐 Server started successfully!" -ForegroundColor Green
        
        while ($listener.IsListening) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response
            
            $localPath = $request.Url.LocalPath
            if ($localPath -eq "/") { $localPath = "/index.html" }
            
            $filePath = Join-Path (Get-Location) $localPath.TrimStart('/')
            
            if (Test-Path $filePath) {
                $content = Get-Content $filePath -Raw -Encoding Byte
                $response.ContentLength64 = $content.Length
                $response.OutputStream.Write($content, 0, $content.Length)
            } else {
                $response.StatusCode = 404
                $notFound = [System.Text.Encoding]::UTF8.GetBytes("404 - File Not Found")
                $response.ContentLength64 = $notFound.Length
                $response.OutputStream.Write($notFound, 0, $notFound.Length)
            }
            
            $response.Close()
        }
    }
} catch {
    Write-Host "❌ Error starting server: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "📋 Manual Instructions:" -ForegroundColor Yellow
    Write-Host "1. Install Python from python.org" -ForegroundColor White
    Write-Host "2. Or copy the 'build\web' folder to any web server" -ForegroundColor White
    Write-Host "3. Or use VS Code Live Server extension" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")