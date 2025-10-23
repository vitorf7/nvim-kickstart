return {
  cmd = { 'golangci-lint-langserver' },
  filetypes = { 'go', 'gomod', 'gowork', 'gosum' },
  init_options = {
    command = { 'golangci-lint', 'run', '--output.json.path', 'stdout', '--show-stats=false', '--issues-exit-code=1', '--path-mode=abs' },
  },
  -- "golangci-lint",
  -- 			"run",
  -- 			"--output.json.path",
  -- 			"stdout",
  -- 			"--show-stats=false",
  -- 			"--issues-exit-code=1",
  -- 			"--path-mode=abs",
}
