return {
  default_config = {
    name = 'jinja-lsp',
    cmd = { vim.stdpath 'data' .. '/mason/bin/jinja-lsp' },
    filetypes = { 'html', 'jinja', 'rs', 'css' },
    root_dir = function(fname)
      return '.'
      --return nvim_lsp.util.find_git_ancestor(fname)
    end,
    init_options = {
      templates = './templates',
      backend = { './src' },
      lang = 'rust',
    },
  },
}
