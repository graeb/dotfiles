return {
  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    keys = {
      {
        "<leader>ct",
        "<Esc><cmd>CodeSnap<cr>",
        mode = "x",
        desc = "Save selected code snapshot into clipboard",
      },
      {
        "<leader>cT",
        "<Esc><cmd>CodeSnapSave<cr>",
        mode = "x",
        desc = "Save selected code snapshot in ~/Pictures",
      },
    },
    opts = {
      save_path = "~/Pictures/Screenshots",
      has_breadcrumbs = false,
      bg_theme = "sea",
      watermark = "",
    },
  },
}
