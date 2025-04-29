-- lua/plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is too old
    build = function()
      -- For macOS (using Homebrew's GCC for better performance)
      require("nvim-treesitter.install").prefer_git = true
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- disable rtp plugin, as we only need its queries for mini.ai
          -- In case other textobject modules are enabled, we will load them
          -- once nvim-treesitter is loaded
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter-textobjects"]
          if plugin then
            plugin.enabled = false
          end
        end,
      },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["a="] = "@assignment.outer",
            ["i="] = "@assignment.inner",
            ["am"] = "@comment.outer",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]p"] = "@parameter.inner",
            ["]a"] = "@assignment.outer",
            ["]l"] = "@loop.outer",
            ["]i"] = "@conditional.outer",
            ["]b"] = "@block.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]P"] = "@parameter.inner",
            ["]A"] = "@assignment.outer",
            ["]L"] = "@loop.outer",
            ["]I"] = "@conditional.outer",
            ["]B"] = "@block.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[p"] = "@parameter.inner",
            ["[a"] = "@assignment.outer",
            ["[l"] = "@loop.outer",
            ["[i"] = "@conditional.outer",
            ["[b"] = "@block.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[P"] = "@parameter.inner",
            ["[A"] = "@assignment.outer",
            ["[L"] = "@loop.outer",
            ["[I"] = "@conditional.outer",
            ["[B"] = "@block.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sn"] = "@parameter.inner",
            ["<leader>sf"] = "@function.outer",
            ["<leader>sa"] = "@assignment.outer",
          },
          swap_previous = {
            ["<leader>sp"] = "@parameter.inner",
            ["<leader>sF"] = "@function.outer",
            ["<leader>sA"] = "@assignment.outer",
          },
        },
      },
    },
    config = function(_, opts)
      -- Load nvim-treesitter-textobjects instead of using lazy's
      -- dependencies system to make sure the core plugin is loaded first
      if opts.textobjects then
        require("lazy").load({ plugins = { "nvim-treesitter-textobjects" } })
      end

      -- macOS-specific compiler settings
      require("nvim-treesitter.install").compilers = { "gcc-11", "gcc", "clang", "cl" }
      
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
