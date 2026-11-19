-- custOS desktop shell
local WindowManager = require("desktop.windowmanager")
local Desktop = {}
Desktop.__index = Desktop

local function safeRead(path)
    if not fs.exists(path) then return nil end
    local f = fs.open(path, "r")
    if not f then return nil end
    local value = f.readAll()
    f.close()
    return value
end

function Desktop.new(kernel)
    return setmetatable({
        kernel = kernel,
        running = true,
        manager = WindowManager.new(),
        menuOpen = false,
        powerOpen = false,
        selected = 1,
        apps = {
            { name = "System information", id = "about" },
            { name = "Notepad", id = "notepad" },
            { name = "Terminal", id = "terminal" }
        }
    }, Desktop)
end

function Desktop:start()
    self.kernel:log("INFO", "Desktop shell ready")
end

function Desktop:draw()
    local w, h = term.getSize()
    term.setBackgroundColor(colors.gray)
    term.clear()

    -- Desktop background and small status label
    term.setCursorPos(2, 2)
    term.setTextColor(colors.lime)
    write("custOS")
    term.setTextColor(colors.lightGray)
    term.setCursorPos(2, 3)
    write("Workstation environment")

    self.manager:draw()

    -- Taskbar
    term.setCursorPos(1, h)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    write(string.rep(" ", w))
    term.setCursorPos(1, h)
    term.setBackgroundColor(colors.green)
    term.setTextColor(colors.white)
    write(" Start ")
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.lightGray)
    local clock = textutils.formatTime(os.time(), true)
    local right = " " .. clock .. " "
    term.setCursorPos(math.max(1, w - #right + 1), h)
    write(right)

    if self.menuOpen then self:drawMenu(w, h) end
    if self.powerOpen then self:drawPower(w, h) end
end

function Desktop:drawMenu(w, h)
    local menuW = math.min(24, w)
    local menuH = math.min(#self.apps + 4, h - 1)
    local x, y = 1, math.max(1, h - menuH)
    for row = 0, menuH - 1 do
        term.setCursorPos(x, y + row)
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        write(string.rep(" ", menuW))
    end
    term.setCursorPos(x + 1, y)
    term.setTextColor(colors.lime)
    write("custOS")
    for i, app in ipairs(self.apps) do
        term.setCursorPos(x + 1, y + i + 1)
        term.setTextColor(i == self.selected and colors.lime or colors.lightGray)
        write((i == self.selected and "> " or "  ") .. app.name:sub(1, menuW - 4))
    end
    term.setCursorPos(x + 1, y + menuH - 1)
    term.setTextColor(colors.orange)
    write("Power options")
end

function Desktop:drawPower(w, h)
    local lines = { "Power options", "Restart", "Shut down", "Cancel" }
    local boxW, boxH = 20, #lines + 2
    local x = math.max(1, math.floor((w - boxW) / 2))
    local y = math.max(1, math.floor((h - boxH) / 2))
    for row = 0, boxH - 1 do
        term.setCursorPos(x, y + row)
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        write(string.rep(" ", boxW))
    end
    for i, line in ipairs(lines) do
        term.setCursorPos(x + 2, y + i - 1)
        term.setTextColor(i == 1 and colors.lime or colors.white)
        write(line)
    end
end

function Desktop:openApp(id)
    self.menuOpen = false
    if id == "about" then
        self.manager:open("System information", {
            "custOS v0.1",
            "Workstation desktop",
            "",
            "Computer: " .. (os.getComputerLabel() or "Unlabelled"),
            "Computer ID: " .. os.getComputerID(),
            "Terminal: " .. tostring(term.getSize()),
            "",
            "The central services are not",
            "configured in this release."
        })
    elseif id == "notepad" then
        self.manager:open("Notepad", {
            "Notepad foundation",
            "",
            "Text editing will arrive in a",
            "later custOS release."
        })
    elseif id == "terminal" then
        self.manager:open("Terminal", {
            "Terminal",
            "",
            "The system shell is available",
            "through the CC:Tweaked shell.",
            "",
            "Close this window to return."
        })
    end
end

function Desktop:handleClick(x, y, h)
    local w = term.getSize()
    if y == h then
        if x <= 8 then
            self.menuOpen = not self.menuOpen
            self.powerOpen = false
        else
            self.powerOpen = not self.powerOpen
            self.menuOpen = false
        end
        return
    end

    if self.powerOpen then
        local boxH = 6
        local top = math.max(1, math.floor((h - boxH) / 2))
        if y == top + 2 then os.reboot()
        elseif y == top + 3 then os.shutdown()
        else self.powerOpen = false end
        return
    end

    if self.menuOpen then
        local menuH = math.min(#self.apps + 4, h - 1)
        local top = math.max(1, h - menuH)
        local index = y - top - 1
        if index >= 1 and index <= #self.apps then
            self:openApp(self.apps[index].id)
        elseif y == top + menuH - 1 then
            self.menuOpen = false
            self.powerOpen = true
        else
            self.menuOpen = false
        end
        return
    end

    self.manager:click(x, y)
end

function Desktop:run()
    self:draw()
    while self.running do
        local event, a, b, c = os.pullEvent()

if event == "term_resize" then
    self:draw()

elseif event == "mouse_click" then
    local _, h = term.getSize()
    self:handleClick(b, c, h)
    self:draw()

elseif event == "monitor_touch" then
    local _, h = term.getSize()
    self:handleClick(b, c, h)
    self:draw()

elseif event == "key" then
    if a == keys.q then
        self.running = false

    elseif self.menuOpen and (a == keys.up or a == keys.down) then
        if a == keys.up then
            self.selected = math.max(1, self.selected - 1)
        else
            self.selected = math.min(#self.apps, self.selected + 1)
        end
        self:draw()

    elseif self.menuOpen and a == keys.enter then
        self:openApp(self.apps[self.selected].id)
        self:draw()

    elseif a == keys.escape then
        self.menuOpen = false
        self.powerOpen = false
        self:draw()
            end
        end
    end
end
return Desktop
