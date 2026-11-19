-- Minimal text-mode window manager
local Manager = {}
Manager.__index = Manager

function Manager.new()
    return setmetatable({ windows = {}, nextId = 1 }, Manager)
end

function Manager:open(title, lines)
    local w, h = term.getSize()
    local width = math.min(math.max(24, #title + 8), math.max(24, w - 2))
    local height = math.min(math.max(8, #lines + 4), math.max(8, h - 3))
    local win = {
        id = self.nextId,
        title = title,
        lines = lines,
        x = math.max(1, math.floor((w - width) / 2)),
        y = math.max(1, math.floor((h - height) / 2)),
        width = width,
        height = height
    }
    self.nextId = self.nextId + 1
    table.insert(self.windows, win)
end

function Manager:draw()
    local win = self.windows[#self.windows]
    if not win then return end
    for row = 0, win.height - 1 do
        term.setCursorPos(win.x, win.y + row)
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        write(string.rep(" ", win.width))
    end
    term.setCursorPos(win.x, win.y)
    term.setBackgroundColor(colors.green)
    term.setTextColor(colors.white)
    write((" " .. win.title):sub(1, win.width - 4))
    term.setCursorPos(win.x + win.width - 2, win.y)
    write("x")
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.lightGray)
    for i, line in ipairs(win.lines) do
        if i <= win.height - 3 then
            term.setCursorPos(win.x + 2, win.y + i + 1)
            write(tostring(line):sub(1, win.width - 4))
        end
    end
end

function Manager:click(x, y)
    local win = self.windows[#self.windows]
    if not win then return end
    if y == win.y and x >= win.x + win.width - 3 then
        table.remove(self.windows)
    end
end

return Manager
