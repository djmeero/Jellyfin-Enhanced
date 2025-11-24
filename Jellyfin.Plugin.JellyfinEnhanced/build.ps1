# -------------------------------
# Build, package, and MD5 Jellyfin plugin DLL
# -------------------------------

# Set paths
$PluginFolder = "C:\work\Jellyfin-Enhanced\Jellyfin.Plugin.JellyfinEnhanced"  # plugin source folder
$BuildOutput = Join-Path $PluginFolder "bin\Release\net9.0"  # output folder
$ZipFile = Join-Path $PluginFolder "Jellyfin.Plugin.JellyfinEnhanced_10.11.0.zip"

# Step 1: Build the plugin
Write-Host "Building plugin..."
dotnet build $PluginFolder -c Release

# Step 2: Remove old ZIP if exists
if (Test-Path $ZipFile) {
    Remove-Item $ZipFile
}

# Step 3: Zip only the DLL and manifest (or other necessary files)
Write-Host "Zipping output DLL..."
$FilesToZip = Get-ChildItem $BuildOutput -Filter "*.dll"
Compress-Archive -Path $FilesToZip.FullName -DestinationPath $ZipFile -Force

# Step 4: Compute MD5 of the ZIP
Write-Host "Computing MD5..."
$MD5 = Get-FileHash $ZipFile -Algorithm MD5
Write-Host "MD5 checksum:" $MD5.Hash