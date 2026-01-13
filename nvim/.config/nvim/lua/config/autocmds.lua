-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Load project-specific config from root directory
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    -- Find project root by looking for markers
    local root_markers = { ".git", ".lazy.lua", ".nvim.lua", "build.zig", "Cargo.toml", "package.json", "Makefile" }
    local root = vim.fs.dirname(vim.fs.find(root_markers, {
      upward = true,
      path = vim.fn.expand("%:p:h"),
    })[1])

    if root then
      -- Try to load .lazy.lua from project root
      local lazy_config = root .. "/.lazy.lua"
      if vim.fn.filereadable(lazy_config) == 1 then
        local content = vim.secure.read(lazy_config)
        if content then
          local chunk, err = loadstring(content, lazy_config)
          if chunk then
            chunk()
          end
        end
      end

      -- Try to load .nvim.lua from project root
      local nvim_config = root .. "/.nvim.lua"
      if vim.fn.filereadable(nvim_config) == 1 then
        local content = vim.secure.read(nvim_config)
        if content then
          local chunk, err = loadstring(content, nvim_config)
          if chunk then
            chunk()
          end
        end
      end
    end
  end,
})
