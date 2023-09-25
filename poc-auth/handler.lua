local BasePlugin = require "kong.plugins.base_plugin"
local http = require "resty.http"
local cjson = require "cjson"

local CustomAuthHandler = BasePlugin:extend()

function CustomAuthHandler:new()
  CustomAuthHandler.super.new(self, "custom-auth")
end

function CustomAuthHandler:access(config)
  CustomAuthHandler.super.access(self)

  -- Obtenha a URL de autenticação externa da configuração
  local external_auth_url = config.external_auth_url

  -- Execute a chamada HTTP para o serviço de autenticação externo
  local httpc = http.new()
  local res, err = httpc:request_uri(external_auth_url, {
    method = "GET"
  })

  if not res then
    kong.log.err("Falha ao fazer a chamada HTTP: " .. err)
    return kong.response.exit(500, { message = "Erro interno do servidor" })
  end

  if res.status == 200 then
    local response_data = cjson.decode(res.body)

    if response_data.result == "true" then
      -- Acesso concedido
      return
    else
      -- Acesso negado
      return kong.response.exit(403, { message = "Acesso negado" })
    end
  else
    kong.log.err("Resposta inesperada do serviço externo: " .. res.status)
    return kong.response.exit(500, { message = "Erro interno do servidor" })
  end
end

return CustomAuthHandler
