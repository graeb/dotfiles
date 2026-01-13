return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = "markdown",
  dependencies = {
    "Saghen/blink.cmp",
  },
  opts = {
    picker = {
      name = "snacks.pick",
    },
    completion = {
      -- Enables completion using nvim_cmp
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
      -- Set to false to disable new note creation in the picker
      create_new = true,
    },
    attachments = {
      img_folder = "Utilities/attachments",
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        return string.format("![%s](%s)", path.name, path)
      end,
    },
    ui = { enable = false },
    workspaces = {
      {
        name = "Brain",
        path = "~/Obsidian",
      },
    },
    note_id_func = function(title)
      -- Function to check if a file already exists
      local function file_exists(name)
        local f = io.open(name, "r")
        if f then
          io.close(f)
          return true
        else
          return false
        end
      end

      local suffix = ""
      if title ~= nil then
        -- Transform the title into a valid file name
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
      else
        -- If no title is provided, generate a random suffix
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end

      -- Base filename (without timestamp)
      local filename = suffix .. ".md"

      -- If the file already exists, add the current date to the name
      if file_exists(filename) then
        local date_suffix = os.date("%Y-%m-%d")
        filename = suffix .. "-" .. date_suffix .. ".md"
      end

      return filename
    end,
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Define a new function to call the ObsidianSearch command
    function ObsidianSearchFunction()
      vim.cmd("ObsidianSearch")
    end

    -- Map the function to <leader>fo
    vim.keymap.set("n", "<leader>fo", ObsidianSearchFunction, { desc = "Obsidian Search" })
  end,
}
