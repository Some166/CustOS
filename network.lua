-- custOS Rednet network service
local Network = {}

local PROTOCOL = "custos_v1"
local modemSide

local function timestamp()
    return textutils.formatTime(os.time(), true)
end

local function log(message)
    local line = "[" .. timestamp() .. "] " .. tostring(message)
    print(line)
    if fs.exists("logs") then
        local file = fs.open("logs/server.log", "a")
        if file then
            file.writeLine(line)
            file.close()
        end
    end
end

function Network.findModem()
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.getType(name) == "modem" then
            return name
        end
    end
    return nil
end

function Network.open(name)
    modemSide = name
    if not rednet.isOpen(name) then
        rednet.open(name)
    end
end

local function sendReply(id, message)
    rednet.send(id, message, PROTOCOL)
end

function Network.listen(version)
    log("Network listener started on protocol " .. PROTOCOL)

    while true do
        local sender, message = rednet.receive(PROTOCOL)
        if type(message) == "table" and type(message.type) == "string" then
            if message.type == "DISCOVER" then
                sendReply(sender, {
                    type = "SERVER_INFO",
                    name = "custOS Central Server",
                    version = version,
                    serverId = os.getComputerID()
                })
                log("Discovery request from computer " .. sender)
            elseif message.type == "STATUS" then
                sendReply(sender, {
                    type = "STATUS",
                    state = "ONLINE",
                    version = version,
                    serverId = os.getComputerID(),
                    time = os.time()
                })
            else
                sendReply(sender, {
                    type = "ERROR",
                    message = "Unknown request type"
                })
                log("Unknown request from computer " .. sender)
            end
        else
            log("Ignored malformed message from computer " .. sender)
        end
    end
end

function Network.console(version)
    while true do
        write("custOS> ")
        local input = read()
        local command = string.lower((input or ""):match("^%s*(.-)%s*$"))

        if command == "help" then
            print("Commands:")
            print("  HELP    - Show this help")
            print("  STATUS  - Show server status")
            print("  ID      - Show this computer's ID")
            print("  VERSION - Show custOS version")
            print("  CLEAR   - Clear the screen")
            print("  REBOOT  - Reboot the computer")
            print("  STOP    - Stop the server")
        elseif command == "status" then
            print("Server: ONLINE")
            print("Computer ID: " .. os.getComputerID())
            print("Modem: " .. tostring(modemSide))
            print("Protocol: " .. PROTOCOL)
        elseif command == "id" then
            print("Computer ID: " .. os.getComputerID())
        elseif command == "version" then
            print("custOS " .. version)
        elseif command == "clear" then
            term.clear()
            term.setCursorPos(1, 1)
        elseif command == "reboot" then
            os.reboot()
        elseif command == "stop" then
            log("Server shutdown requested from console")
            os.shutdown()
        elseif command ~= "" then
            print("Unknown command. Type HELP.")
        end
    end
end

return Network
