return {
  -- filetypes = { 'graphql', 'typescript', 'typescriptreact' },
  root_dir = require('lspconfig').util.root_pattern('.git', 'gqlgen.yaml', 'gqlgen.yml', '.graphqlrc*', '.graphql.config.*', 'graphql.config.*'),
}
