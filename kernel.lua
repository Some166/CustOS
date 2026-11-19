-- custOS kernel bootstrap
local Network = require("network.lua")

local Kernel = {}

local VERSION = "0.1.0"

local function banner()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.lightBlue)
    term.clear()
    term.setCursorPos(1, 1)
    print("========================================")
    print("                 custOS                 ")
    print("          CENTRAL SERVER " .. VERSION .. "          ")
    print("========================================")
    term.setTextColor(colors.white)
    print("Initialising system...")
end

function Kernel.boot()
    banner()

    if not fs.exists("data") then
        fs.makeDir("data")
    end
    if not fs.exists("logs") then
        fs.makeDir("logs")
    end

    local modem = Network.findModem()
    if not modem then
        error("No modem found. Attach a wired or wireless modem and reboot.")
    end

    Network.open(modem)

    print("Filesystem: ready")
    print("Network:    ready")
    print("Modem:      " .. modem)
    print("")
    print("custOS server is online.")
    print("Type HELP for available server commands.")
    print("")

    parallel.waitForAny(
        function() Network.listen(VERSION) end,
        function() Network.console(VERSION) end
    )
end

return Kernel
