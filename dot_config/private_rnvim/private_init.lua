local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
{ 'smoka7/hop.nvim', version = "*", opts = { keys = 'etovxqpdygfblzhckisuran' } },
{ 'kevinhwang91/nvim-ufo', dependencies = { 'kevinhwang91/promise-async' } },
  {
    'isakbm/gitgraph.nvim',
    opts = {
      symbols = {
        merge_commit = 'M',
        commit = '*',
      },
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      hooks = {
        on_select_commit = function(commit)
          print('selected commit:', commit.hash)
        end,
        on_select_range_commit = function(from, to)
          print('selected range:', from.hash, to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gl",
        function()
          require('gitgraph').draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },
{ "rbong/vim-flog",
  lazy = true,
  cmd = { "Flog", "Flogsplit", "Floggit" },
  dependencies = {
    "tpope/vim-fugitive",
  },
},
{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
},
{ "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({ "fzf-native" })
  end
},
'spf13/vim-colors',
'duane9/nvim-rg',
'tpope/vim-repeat',
'christoomey/vim-tmux-navigator',
'rhysd/conflict-marker.vim',
'terryma/vim-multiple-cursors',
'powerline/fonts',
'flazz/vim-colorschemes',
'mbbill/undotree',
'nathanaelkane/vim-indent-guides',
'vim-scripts/restore_view.vim',
'mhinz/vim-signify',
'tpope/vim-abolish',
'osyo-manga/vim-over',
'tpope/vim-fugitive',
'mattn/webapi-vim',
'mattn/gist-vim',
'tpope/vim-commentary',
'NMAC427/guess-indent.nvim',
'luochen1990/rainbow',
'honza/vim-snippets',
'itchyny/lightline.vim',
'itchyny/landscape.vim',
'tpope/vim-dispatch',
'nvim-lua/plenary.nvim',
'towolf/vim-helm',
'tpope/vim-unimpaired',
'Olical/vim-enmasse',
'Shatur/neovim-session-manager',
'pprovost/vim-ps1',
'ryanoasis/vim-devicons',
'will133/vim-dirdiff',
'williamboman/mason.nvim',
'williamboman/mason-lspconfig.nvim',
'mfussenegger/nvim-dap',
{
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    { 'ms-jpq/coq_nvim', branch = 'coq' },
    { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
    { 'ms-jpq/coq.thirdparty', branch = '3p' }
  },
  init = function()
    vim.g.coq_settings = {
      auto_start = true,
      xdg = true,
    }
  end,
}
})

require("mason").setup()
require("guess-indent").setup()

local Path = require('plenary.path')
local config = require('session_manager.config')
local lspconfig = require('lspconfig')
require('session_manager').setup({
  autoload_mode = config.AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true, -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
})

local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands

require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
  { src = "dap", short_name = "dbug" },
  { src = "repl", sh = "zsh", shell = { p = "python3", n = "node" }, max_lines = 99, deadline = 500, unsafe = { "rm", "poweroff", "mv" } }
}

require("neo-tree").setup{
  window = {
    mappings = {
      ["i"] = "open_split",
      ["s"] = "open_vsplit",
      ["o"] = "open",
      ["I"] = "show_file_details",
    }
  }
}

lspconfig.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { ignore = {'E501'}  },
        black = { enabled = false },
        pylsp_mypy = { enabled = false }
        }
      }
    }
  }

lspconfig.terraformls.setup{}

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

lspconfig.ts_ls.setup{}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
})

local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

if not configs.helm_ls then
  configs.helm_ls = {
    default_config = {
      cmd = {"helm_ls", "serve"},
      filetypes = {'helm'},
      root_dir = function(fname)
        return util.root_pattern('Chart.yaml')(fname)
      end,
    },
  }
end

lspconfig.rust_analyzer.setup({})

lspconfig.helm_ls.setup {
  filetypes = {"helm"},
  cmd = {"helm_ls", "serve"},
}

lspconfig.groovyls.setup{
    cmd = { "java", "-jar", "/home/frizzr/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar" }
}

lspconfig.gopls.setup({})

vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "<c-g>", "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
vim.keymap.set("n", "<c-\\>", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })

-- nvim-ufo config
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = false -- off initially, toggle on/off with 'zi'

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

local coq = require('coq')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = lspconfig.util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    lspconfig[ls].setup({
        capabilities = coq.lsp_ensure_capabilities(capabilities)
        -- you can add other fields for setting up lsp server in this table
    })
end
local ftMap = {
    vim = 'indent',
    python = {'indent'},
    git = ''
}
require('ufo').setup({
    open_fold_hl_timeout = 150,
    close_fold_kinds_for_ft = {'imports', 'comment'},
    preview = {
        win_config = {
            border = {'', 'Ä', '', '', '', 'Ä', '', ''},
            winhighlight = 'Normal:Folded',
            winblend = 0
        },
        mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
        }
    },
    provider_selector = function(bufnr, filetype, buftype)
        -- if you prefer treesitter provider rather than lsp,
        -- return ftMap[filetype] or {'treesitter', 'indent'}
        return ftMap[filetype]

        -- refer to ./doc/example.lua for detail
    end
})
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set('n', 'K', function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        -- choose one of coc.nvim and nvim lsp
        vim.lsp.buf.hover()
    end
end)

-- hop.nvim
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char2({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char2({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char2({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char2({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})
vim.keymap.set('', 's', function()
  vim.o.foldenable = false
  hop.hint_lines_skip_whitespace({ multi_windows = true })
end, {remap=true})
vim.keymap.set('', 'S', function()
  vim.o.foldenable = false
  hop.hint_char2({ current_line_only = false, multi_windows = true })
end, {remap=true})

vim.cmd("source ~/.config/rnvim/setopts.vim")

