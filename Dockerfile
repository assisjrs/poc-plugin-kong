FROM kong:2.8.1-alpine

USER root
RUN luarocks install kong-oidc && \
    luarocks install kong-jwt2header && \
    luarocks install kong-upstream-jwt

USER kong

# Copie os arquivos do seu plugin para o diretório de plugins do Kong
COPY poc-auth /usr/local/share/lua/5.1/kong/plugins/
