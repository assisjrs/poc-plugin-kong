return {
    no_consumer = true, -- Não associar com um consumer, pois é global
    fields = {
      external_auth_url = { type = "url", required = true, default = "http://seuservicoexterno.com/auth-endpoint" }
    },
    self_check = function(schema, plugin_t, dao, is_updating)
      -- Adicione verificações de validação personalizadas aqui, se necessário
      return true
    end
  }
  