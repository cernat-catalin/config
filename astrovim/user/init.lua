local config = {
  -- Configure plugins
  plugins = {
    ["cinnamon"] = function(config)
      config.scroll_limit = 0
        return config
    end,
  }
}

return config
