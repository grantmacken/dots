local _M = {}
 -- Some path manipulation utilities
  local function is_dir(filename)
    local stat = vim.loop.fs_stat(filename)
    return stat and stat.type == 'directory' or false
  end

  local path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
  -- Asumes filepath is a file.
  local function dirname(filepath)
    local is_changed = false
    local result = filepath:gsub(path_sep.."([^"..path_sep.."]+)$", function()
      is_changed = true
      return ""
    end)
    return result, is_changed
  end

  local function path_join(...)
    return table.concat(vim.tbl_flatten {...}, path_sep)
  end

  -- Ascend the buffer's path until we find the rootdir.
  -- is_root_path is a function which returns bool
  local function buffer_find_root_dir(bufnr, is_root_path)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if vim.fn.filereadable(bufname) == 0 then
      return nil
    end
    local dir = bufname
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      local did_change
      dir, did_change = dirname(dir)
      if is_root_path(dir, bufname) then
        return dir, bufname
      end
      -- If we can't ascend further, then stop looking.
      if not did_change then
        return nil
      end
    end
  end

-- A table to store our root_dir to client_id lookup. We want one LSP per
  -- root directory, and this is how we assert that.
  local erlang_lsps = {}
  -- Which filetypes we want to consider.
  local erlang_filetypes = {
    ["erlang"] = true;
  }

 -- Create a template configuration for a server to start, minus the root_dir
  -- which we will specify later.
  local erlang_lsp_config = {
    name = "els";
    cmd = {"/home/gmack/.cache/nvim/nvim_lsp/erlang_ls/_build/default/bin/erlang_ls","--transport","stdio"};
  }

  -- This needs to be global so that we can call it from the autocmd.
  function _M.check_start_erlang_lsp()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Filter which files we are considering.
    if not erlang_filetypes[vim.api.nvim_buf_get_option(bufnr, 'filetype')] then
      return
    end
    -- Try to find our root directory. We will define this as a directory which contains
    -- node_modules. Another choice would be to check for `package.json`, or for `.git`.
    local root_dir = buffer_find_root_dir(bufnr, function(dir)
      return is_dir(path_join(dir, '.git'))
    end)
    -- We couldn't find a root directory, so ignore this file.
    if not root_dir then return end

    -- Check if we have a client alredy or start and store it.
    local client_id = erlang_lsps[root_dir]
    if not client_id then
      local new_config = vim.tbl_extend("error", erlang_lsp_config, {
        root_dir = root_dir;
      })
      client_id = vim.lsp.start_client(new_config)
      erlang_lsps[root_dir] = client_id
    end
    -- Finally, attach to the buffer to track changes. This will do nothing if we
    -- are already attached.
    vim.lsp.buf_attach_client(bufnr, client_id)
  end

return _M
