-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.keymaps")
require("config.options")

local opts = {
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { "catppuccin" },
  },
  rtp = {
    disabled_plugins = {
      "example_plugin",
    },
    change_detection = {
      notify = true,
    },
  },
}
require("lazy").setup("plugins", opts)
require("lazy").setup({
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        require("supermaven-nvim").setup({
          keymaps = {
            accept_suggestion = "<Tab>",
            clear_suggestion = "<C-]>",
            accept_word = "<C-j>",
          },
          ignore_filetypes = { cpp = true }, -- or { "cpp", }
          color = {
            suggestion_color = "#ffffff",
            cterm = 244,
          },
          log_level = "info", -- set to "off" to disable logging completely
          disable_inline_completion = false, -- disables inline completion for use with cmp
          disable_keymaps = false, -- disables built in keymaps for more manual control
          condition = function()
            return string.match(vim.fn.expand("%:t"), ".md")
          end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
        }),
      })
    end,
  },
}, {})
