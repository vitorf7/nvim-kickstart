return {
  'David-Kunz/gen.nvim',
  event = 'VimEnter',
  keys = {
    { '<leader>Ao', ':Gen<CR>', desc = 'Ollama Generate', mode = { 'n', 'v' } },
  },
  config = function(_, _)
    require('gen').model = 'deepseek-coder:6.7b'
    require('gen').prompts['Explain_Code'] = {
      prompt = 'Please explain the following code:\n```$filetype\n$text```',
      model = 'deepseek-coder:6.7b',
    }
  end,
}
