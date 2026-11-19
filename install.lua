-- custOS network installer
-- Upload the project to https://github.com/Some166/CustOS first.
local BASE = "https://raw.githubusercontent.com/Some166/CustOS/main/"
local files = {
    "startup.lua",
    "boot.lua",
    "kernel.lua",
    "desktop.lua",
    "windowmanager.lua",
    "defaults.lua",
    "about.lua",
    "notepad.lua"
}

if not http then
    printError("HTTP is disabled. Enable HTTP in the CC:Tweaked server config.")
    return
end

local function ensureDir(path)
    if not fs.exists(path) then fs.makeDir(path) end
end

print("custOS installer v0.1")
print("Installing workstation files...")
for _, path in ipairs(files) do
    local response, err = http.get(BASE .. path)
    if not response then
        printError("Download failed: " .. path .. " (" .. tostring(err) .. ")")
        print("No further files were installed.")
        return
    end
    local data = response.readAll()
    response.close()
    local parent = fs.getDir(path)
    if parent ~= "" then ensureDir(parent) end
    local handle = fs.open(path, "w")
    if not handle then
        printError("Could not write: " .. path)
        return
    end
    handle.write(data)
    handle.close()
    print("Installed " .. path)
end

print("")
print("custOS installation complete.")
print("Restarting in 3 seconds...")
sleep(3)
os.reboot()
