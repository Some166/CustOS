-- Temporary custOS network discovery test.
-- Run this on any computer with a modem attached.

local PROTOCOL = "custos_v1"
local modemFound = false

for _, name in ipairs(peripheral.getNames()) do
    if peripheral.getType(name) == "modem" then
        if not rednet.isOpen(name) then rednet.open(name) end
        modemFound = true
        print("Opened modem: " .. name)
        break
    end
end

if not modemFound then
    print("No modem found. Attach a modem and try again.")
    return
end

print("Searching for custOS servers...")
rednet.broadcast({ type = "DISCOVER" }, PROTOCOL)

local sender, reply = rednet.receive(PROTOCOL, 5)
if sender and type(reply) == "table" and reply.type == "SERVER_INFO" then
    print("Found " .. tostring(reply.name))
    print("Computer ID: " .. tostring(reply.serverId))
    print("Version: " .. tostring(reply.version))
else
    print("No custOS server replied within 5 seconds.")
end
