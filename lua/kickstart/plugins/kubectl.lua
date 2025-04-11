local function get_aws_env_vars()
  local result = {}
  local varNames = { 'AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY', 'AWS_DEFAULT_REGION', 'AWS_DEFAULT_OUTPUT' }
  for _, var in ipairs(varNames) do
    result[var] = os.getenv(var)
  end
  return result
end

return {
  {
    'ramilito/kubectl.nvim',
    keys = {
      {
        '<leader>k',
        function()
          require('kubectl').toggle()
        end,
        desc = 'Toggle K8s',
        mode = 'n',
      },
    },
    opts = {
      namespace = 'contact-channels',
      namespace_fallback = { 'help-and-support', 'crm' },
      kubectl_cmd = {
        cmd = 'kubectl',
        env = get_aws_env_vars(),
        args = {
          '--context',
          'dev-aws',
          '--namespace',
          'contact-channels',
        },
        persist_context_change = true,
      },
    },
    config = function(_, opts)
      require('kubectl').setup(opts)
    end,
  },
}
