return {
  {
    "nvim-mini/mini.animate",
    version = "*",
    event = "VeryLazy",
    opts = function()
      -- Don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        -- Animate window resize
        resize = {
          timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
        },
        -- Animate window open
        open = {
          timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
        },
        -- Animate window close
        close = {
          timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
        },
        -- Animate cursor only for large jumps (page jumps)
        cursor = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          path = function(destination)
            -- Skip animation if mouse scrolled
            if mouse_scrolled then
              mouse_scrolled = false
              return {}
            end

            -- Get current cursor position (before the jump)
            local source = vim.api.nvim_win_get_cursor(0)
            local source_line = source[1]
            local dest_line = destination[1]
            local line_diff = math.abs(dest_line - source_line)

            -- Only animate if jumping more than half a screen
            local threshold = math.floor(vim.api.nvim_win_get_height(0) / 2)

            if line_diff > threshold then
              -- Return default line path for animation
              return animate.gen_path.line()(destination)
            else
              -- No animation for small movements
              return {}
            end
          end,
        },
        -- Disable scroll animation
        scroll = {
          enable = false,
        },
      }
    end,
  },
}
