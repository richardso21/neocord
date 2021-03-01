local Log = {}

Log.codes = {}
Log.levels = {
    { "debug", "Comment" },
    { "info", "None" },
    { "warn", "WarningMsg" },
    { "error", "ErrorMsg" },
}

function Log:init(options)
    self.level = options.level
    return self
end

-- Initialize logger with log functions for each level
for i = 1, #Log.levels do
    local level, hl = unpack(Log.levels[i])

    Log.codes[level] = i

    Log[level] = function(self, message)
        -- Skip if log level is not set or the log is below the configured or default level
        if not self.level or self.codes[level] < self.codes[self.level] then
            return
        end

        vim.schedule(function()
            vim.cmd(string.format("echohl %s", hl))
            vim.cmd(string.format([[echom "[%s] %s"]], "presence.nvim", vim.fn.escape(message, '"')))
            vim.cmd("echohl NONE")
        end)
    end
end

return Log