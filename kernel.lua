-- custOS kernel core (v0.1)
local Kernel = {}
Kernel.__index = Kernel

function Kernel.new()
    return setmetatable({
        version = "0.1",
        services = {},
        running = false,
        bootTime = os.clock()
    }, Kernel)
end

function Kernel:log(level, message)
    local line = string.format("[%s] %s", level, tostring(message))
    if self.logger then
        self.logger(line)
    else
        print(line)
    end
end

function Kernel:registerService(name, service)
    if type(name) ~= "string" or type(service) ~= "table" then
        error("registerService expects a name and service table")
    end
    self.services[name] = service
end

function Kernel:startServices()
    for name, service in pairs(self.services) do
        if type(service.start) == "function" then
            local ok, err = pcall(service.start, service, self)
            if not ok then
                self:log("ERROR", "Service '" .. name .. "' failed: " .. tostring(err))
            else
                self:log("INFO", "Started service: " .. name)
            end
        end
    end
end

function Kernel:boot()
    self.logger = function(line)
        if self.logFile then
            local file = fs.open(self.logFile, "a")
            if file then file.writeLine(line); file.close() end
        end
    end
    self.logFile = "/custos/logs/system.log"
    if not fs.exists("/custos") then fs.makeDir("/custos") end
    if not fs.exists("/custos/logs") then fs.makeDir("/custos/logs") end

    self:log("INFO", "custOS kernel " .. self.version .. " initialising")
    self.running = true

    local Desktop = require("desktop.desktop")
    local desktop = Desktop.new(self)
    self:registerService("desktop", desktop)
    self:startServices()

    if desktop.run then desktop:run() end
    self.running = false
    self:log("INFO", "System session ended")
end

return Kernel
