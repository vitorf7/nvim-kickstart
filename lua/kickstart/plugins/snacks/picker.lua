return {
  enabled = true,
  win = {
    input = {
      keys = {
        -- to close the picker on ESC instead of going to normal mode,
        -- add the following keymap to your config
        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
        -- I'm used to scrolling like this in LazyGit
        ['J'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
        ['K'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
        ['H'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
        ['L'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
      },
    },
  },
}
