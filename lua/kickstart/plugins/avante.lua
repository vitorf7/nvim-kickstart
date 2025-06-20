-- -- return {}
-- -- Ollama API Documentation https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion
-- local role_map = {
--   user = 'user',
--   assistant = 'assistant',
--   system = 'system',
--   tool = 'tool',
-- }
--
-- ---@param opts AvantePromptOptions
-- local parse_messages = function(self, opts)
--   local messages = {}
--   local has_images = opts.image_paths and #opts.image_paths > 0
--   -- Ensure opts.messages is always a table
--   local msg_list = opts.messages or {}
--   -- Convert Avante messages to Ollama format
--   for _, msg in ipairs(msg_list) do
--     local role = role_map[msg.role] or 'assistant'
--     local content = msg.content or '' -- Default content to empty string
--     -- Handle multimodal content if images are present
--     -- *Experimental* not tested
--     if has_images and role == 'user' then
--       local message_content = {
--         role = role,
--         content = content,
--         images = {},
--       }
--       for _, image_path in ipairs(opts.image_paths) do
--         local base64_content = vim.fn.system(string.format('base64 -w 0 %s', image_path)):gsub('\n', '')
--         table.insert(message_content.images, 'data:image/png;base64,' .. base64_content)
--       end
--       table.insert(messages, message_content)
--     else
--       table.insert(messages, {
--         role = role,
--         content = content,
--       })
--     end
--   end
--   return messages
-- end
--
-- local function parse_curl_args(self, code_opts)
--   -- Create the messages array starting with the system message
--   local messages = {
--     { role = 'system', content = code_opts.system_prompt },
--   }
--   -- Extend messages with the parsed conversation messages
--   vim.list_extend(messages, self:parse_messages(code_opts))
--   -- Construct options separately for clarity
--   local options = {
--     num_ctx = (self.options and self.options.num_ctx) or 4096,
--     temperature = code_opts.temperature or (self.options and self.options.temperature) or 0,
--   }
--   -- Check if tools table is empty
--   local tools = (code_opts.tools and next(code_opts.tools)) and code_opts.tools or nil
--   -- Return the final request table
--   return {
--     url = self.endpoint .. '/api/chat',
--     headers = {
--       Accept = 'application/json',
--       ['Content-Type'] = 'application/json',
--     },
--     body = {
--       model = self.model,
--       messages = messages,
--       options = options,
--       -- tools = tools, -- Optional tool support
--       stream = true, -- Keep streaming enabled
--     },
--   }
-- end
--
-- local function parse_stream_data(data, handler_opts)
--   local json_data = vim.fn.json_decode(data)
--   if json_data then
--     if json_data.done then
--       handler_opts.on_stop { reason = json_data.done_reason or 'stop' }
--       return
--     end
--     if json_data.message then
--       local content = json_data.message.content
--       if content and content ~= '' then
--         handler_opts.on_chunk(content)
--       end
--     end
--     -- Handle tool calls if present
--     if json_data.tool_calls then
--       for _, tool in ipairs(json_data.tool_calls) do
--         handler_opts.on_tool(tool)
--       end
--     end
--   end
-- end
--
-- ---@type AvanteProvider
-- local ollama = {
--   api_key_name = '',
--   endpoint = 'http://127.0.0.1:11434',
--   model = 'qwen2.5-coder:7b', -- Specify your model here
--   parse_messages = parse_messages,
--   parse_curl_args = parse_curl_args,
--   parse_stream_data = parse_stream_data,
-- }
--
return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  enabled = true,
  version = false, -- set this if you want to always pull the latest change
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  opts = {
    debug = true,
    provider = 'ollama',
    providers = {
      ollama = {
        endpoint = 'http://127.0.0.1:11434', -- Note that there is no /v1 at the end.
        model = 'qwen2.5-coder:7b', -- Specify your model here
        -- model = 'deepseek-r1:14b',
        stream = true,
      },
    },
    windows = {
      postion = 'right',
      width = 40,
      sidebar_header = {
        enabled = true,
        align = 'center',
        rounded = true,
      },
      input = {
        prefix = ' ',
        height = 12, -- Height of the input window in vertical layout
      },
    },
    file_selector = {
      provider = 'snacks',
    },
  },

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = true,
          prompt_for_file_name = true,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = false,
        },
      },
    },
  },

  config = function(_, opts)
    require('avante_lib').load()
    require('avante').setup(opts)
  end,
}
