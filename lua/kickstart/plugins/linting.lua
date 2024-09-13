return {
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      sql = { 'sqlfluff' },
      mysql = { 'sqlfluff' },
      markdown = { 'markdownlint' },
      dockerfile = { 'hadolint' },
      terraform = { 'terraform_validate' },
      tf = { 'terraform_validate' },
      yaml = { 'yamllint' },
    }
  end,
}
