# Script tự động fix yarn.lock
# Tìm và chạy yarn install để update yarn.lock

Write-Host "🔍 Đang tìm Node.js và Yarn..." -ForegroundColor Cyan

# Tìm Node.js trong các vị trí thường gặp
$nodePaths = @(
    "node",
    "$env:USERPROFILE\.volta\bin\node.exe",
    "$env:LOCALAPPDATA\Programs\Volta\node.exe",
    "$env:ProgramFiles\nodejs\node.exe",
    "$env:ProgramFiles(x86)\nodejs\node.exe"
)

$nodeCmd = $null
foreach ($path in $nodePaths) {
    if ($path -eq "node") {
        $nodeCmd = Get-Command node -ErrorAction SilentlyContinue
        if ($nodeCmd) {
            $nodeCmd = $nodeCmd.Source
            break
        }
    } else {
        if (Test-Path $path) {
            $nodeCmd = $path
            break
        }
    }
}

# Tìm yarn trong các vị trí thường gặp (ưu tiên Volta)
$yarnPaths = @(
    "$env:USERPROFILE\.volta\bin\yarn.cmd",
    "$env:LOCALAPPDATA\Programs\Volta\bin\yarn.cmd",
    "yarn",
    "$env:LOCALAPPDATA\Yarn\bin\yarn.cmd",
    "$env:APPDATA\npm\yarn.cmd",
    "$env:ProgramFiles\nodejs\yarn.cmd",
    "$env:ProgramFiles(x86)\nodejs\yarn.cmd"
)

$yarnCmd = $null
foreach ($path in $yarnPaths) {
    if ($path -eq "yarn") {
        $yarnCmd = Get-Command yarn -ErrorAction SilentlyContinue
        if ($yarnCmd) {
            $yarnCmd = $yarnCmd.Source
            break
        }
    } else {
        if (Test-Path $path) {
            $yarnCmd = $path
            break
        }
    }
}

# Nếu tìm thấy Volta, thêm vào PATH
if (Test-Path "$env:USERPROFILE\.volta\bin") {
    $env:PATH = "$env:USERPROFILE\.volta\bin;$env:PATH"
    Write-Host "✅ Đã thêm Volta vào PATH" -ForegroundColor Green
}
if (Test-Path "$env:LOCALAPPDATA\Programs\Volta\bin") {
    $env:PATH = "$env:LOCALAPPDATA\Programs\Volta\bin;$env:PATH"
    Write-Host "✅ Đã thêm Volta vào PATH" -ForegroundColor Green
}

# Thử lại tìm yarn sau khi thêm Volta vào PATH
if (-not $yarnCmd) {
    $yarnCmd = Get-Command yarn -ErrorAction SilentlyContinue
    if ($yarnCmd) {
        $yarnCmd = $yarnCmd.Source
    }
}

if (-not $nodeCmd) {
    Write-Host "❌ Không tìm thấy Node.js!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Vui lòng cài đặt Node.js bằng một trong các cách sau:" -ForegroundColor Yellow
    Write-Host "1. Cài Volta: https://volta.sh/ (khuyến nghị)" -ForegroundColor Yellow
    Write-Host "2. Cài Node.js: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

if (-not $yarnCmd) {
    Write-Host "❌ Không tìm thấy Yarn!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Vui lòng cài đặt Yarn bằng một trong các cách sau:" -ForegroundColor Yellow
    Write-Host "1. Cài Volta: https://volta.sh/ (khuyến nghị)" -ForegroundColor Yellow
    Write-Host "2. Cài Yarn qua npm: npm install -g yarn" -ForegroundColor Yellow
    Write-Host "3. Cài Yarn qua Corepack: corepack enable" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Tìm thấy Node.js tại: $nodeCmd" -ForegroundColor Green

Write-Host "✅ Tìm thấy Yarn tại: $yarnCmd" -ForegroundColor Green
Write-Host ""

# Thêm Node.js vào PATH
$nodeDir = Split-Path $nodeCmd -Parent
if ($nodeDir -notin ($env:PATH -split ';')) {
    $env:PATH = "$nodeDir;$env:PATH"
    Write-Host "✅ Đã thêm Node.js vào PATH" -ForegroundColor Green
    Write-Host ""
}

# Kiểm tra yarn version
Write-Host "📦 Yarn version:" -ForegroundColor Cyan
$yarnVersion = & $yarnCmd --version 2>&1
Write-Host $yarnVersion
Write-Host ""

# Kiểm tra nếu là Yarn v1 (không hỗ trợ patch syntax)
if ($yarnVersion -match "^1\.") {
    Write-Host "⚠️  Phát hiện Yarn v1, project này cần Yarn v4!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔄 Đang cài Yarn v4 qua corepack..." -ForegroundColor Cyan
    
    # Thử dùng corepack để cài Yarn v4
    $corepackCmd = Get-Command corepack -ErrorAction SilentlyContinue
    if ($corepackCmd) {
        Write-Host "✅ Tìm thấy corepack" -ForegroundColor Green
        & corepack enable
        & corepack prepare yarn@4.9.1 --activate
        Write-Host "✅ Đã cài Yarn v4.9.1" -ForegroundColor Green
        
        # Tìm lại yarn sau khi cài
        $yarnCmd = Get-Command yarn -ErrorAction SilentlyContinue
        if ($yarnCmd) {
            $yarnCmd = $yarnCmd.Source
            Write-Host "✅ Tìm thấy Yarn v4 tại: $yarnCmd" -ForegroundColor Green
            $yarnVersion = & $yarnCmd --version 2>&1
            Write-Host "📦 Yarn version: $yarnVersion" -ForegroundColor Cyan
        } else {
            Write-Host "❌ Không tìm thấy Yarn v4 sau khi cài" -ForegroundColor Red
            Write-Host ""
            Write-Host "Vui lòng cài Volta: https://volta.sh/" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "❌ Không tìm thấy corepack" -ForegroundColor Red
        Write-Host ""
        Write-Host "Vui lòng cài Volta để sử dụng đúng version:" -ForegroundColor Yellow
        Write-Host "1. Tải Volta: https://volta.sh/" -ForegroundColor Yellow
        Write-Host "2. Sau khi cài, chạy lại script này" -ForegroundColor Yellow
        exit 1
    }
    Write-Host ""
}

# Backup yarn.lock hiện tại
if (Test-Path yarn.lock) {
    Write-Host "💾 Đang backup yarn.lock..." -ForegroundColor Cyan
    Copy-Item yarn.lock yarn.lock.backup -Force
    Write-Host "✅ Đã backup yarn.lock thành yarn.lock.backup" -ForegroundColor Green
    Write-Host ""
}

# Xóa yarn.lock và tạo lại
Write-Host "🗑️  Đang xóa yarn.lock cũ..." -ForegroundColor Cyan
Remove-Item yarn.lock -Force -ErrorAction SilentlyContinue
New-Item yarn.lock -ItemType File -Force | Out-Null
Write-Host "✅ Đã tạo yarn.lock mới" -ForegroundColor Green
Write-Host ""

# Chạy yarn install --mode=update-lockfile
Write-Host "📥 Đang update yarn.lock..." -ForegroundColor Cyan
$updateResult = & $yarnCmd install --mode=update-lockfile 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Lỗi khi update yarn.lock:" -ForegroundColor Red
    Write-Host $updateResult
    exit 1
}
Write-Host "✅ Đã update yarn.lock" -ForegroundColor Green
Write-Host ""

# Chạy yarn install để link packages
Write-Host "🔗 Đang link packages..." -ForegroundColor Cyan
$installResult = & $yarnCmd install 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Lỗi khi install packages:" -ForegroundColor Red
    Write-Host $installResult
    exit 1
}
Write-Host "✅ Đã install packages thành công" -ForegroundColor Green
Write-Host ""

# Kiểm tra git status
Write-Host "📊 Kiểm tra thay đổi..." -ForegroundColor Cyan
$gitStatus = git status yarn.lock --porcelain
if ($gitStatus) {
    Write-Host "✅ yarn.lock đã thay đổi" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 Đang commit và push yarn.lock..." -ForegroundColor Cyan
    git add yarn.lock
    git commit -m "chore: update yarn.lock to match package.json dependencies"
    git push origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Đã commit và push yarn.lock thành công!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🎉 Hoàn thành! yarn.lock đã được update và push lên GitHub." -ForegroundColor Green
    } else {
        Write-Host "❌ Lỗi khi push lên GitHub" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "ℹ️  yarn.lock không có thay đổi" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "✅ yarn.lock đã đúng, không cần update!" -ForegroundColor Green
}

Write-Host ""
Write-Host "✨ Script hoàn thành!" -ForegroundColor Cyan

