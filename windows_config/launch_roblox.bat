@echo off
title Custom OS Shell Launcher - ROBLOX Native
echo ====================================================
echo  BOOTING SYSTEM DIRECTLY TO RUNTIME ENVIRONMENT
echo ====================================================

echo [1/3] Initializing Subsystem Network Drivers...
wpeinit

echo [2/3] Mapping Virtual Storage Mounts...
ipconfig | findstr "IPv4"

echo [3/3] Locating and Executing Roblox Client Engine...
if exist "X:\Roblox\Player\RobloxPlayerBeta.exe" (
    echo Launching Roblox Client with Realtime Thread Priority...
    start /realtime "" "X:\Roblox\Player\RobloxPlayerBeta.exe"
) else (
    echo ERROR: Roblox executable not found at X:\Roblox\Player\
    echo Please drop your 64-bit Windows Roblox client folders into this directory.
    cmd.exe
)
