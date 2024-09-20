return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Pesquisar por um termo em todos os arquivos",
    },
    -- Você pode adicionar mais atalhos personalizados aqui
  },
  opts = {
    defaults = {
      -- Adicione quaisquer opções padrão que você queira aqui
    },
    pickers = {
      live_grep = {
        additional_args = function(_)
          return { "--hidden" }
        end,
      },
    },
  },
}
