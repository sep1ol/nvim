-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.keymaps")
require("config.options")

local opts = {
  defaults = {
    lazy = true,
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

-- Colorscheme
require("bluloco").setup({
  style = "dark", -- "auto" | "dark" | "light"
  transparent = true,
  italics = true,
  terminal = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
  guicursor = true,
})
vim.opt.termguicolors = true
vim.cmd("colorscheme bluloco")

-- Neo-tree context
require("neo-tree").setup({
  window = {
    position = "float",
    mappings = {
      ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
      ["<C-b>"] = { "scroll_preview", config = { direction = 10 } },
      ["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
      ["l"] = { "open" },
      ["h"] = { "close_node" },
    },
  },
})

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- Could be '■', '▎', 'x'
    spacing = 4,
    source = "if_many",
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
  },
  float = {
    source = true,
    border = "rounded",
    style = "minimal",
    header = "",
    prefix = "",
    format = function(diagnostic)
      if diagnostic.source then
        return string.format("%s: %s", diagnostic.source, diagnostic.message)
      end
      return diagnostic.message
    end,
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    max_width = 120, -- Adjust this value to set the maximum width
    max_height = 10, -- Adjust this value to set the maximum height
    wrap = true, -- This enables line wrapping in the floating window
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Customize diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Add keymap to open float
local function toggle_diagnostics_or_neotree()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(current_buf, { lnum = current_line })

  if #diagnostics > 0 then
    -- Há diagnósticos na linha atual, então abra o float de diagnóstico
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  else
    -- Não há diagnósticos, então toggle o Neotree
    vim.cmd("Neotree toggle")
  end
end

vim.keymap.set(
  "n",
  "<leader>e",
  toggle_diagnostics_or_neotree,
  { noremap = true, silent = true, desc = "Toggle diagnostic float or Neotree" }
)

-- Optional: Add keymap to go to next/previous diagnostic
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
