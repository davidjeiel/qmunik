# Base para a aplicação Node.js
FROM node:16 AS node-builder

# Diretório de trabalho
WORKDIR /home/qmunik

# Copiar arquivos necessários para instalar as dependências
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar o restante do código para o diretório de trabalho
COPY . .

# Construir o aplicativo, se necessário (opcional)
# RUN npm run build

# Base para o servidor Nginx
FROM nginx:alpine

# Copiar os arquivos estáticos para o diretório padrão do Nginx
COPY public /usr/share/nginx/html

# Copiar o arquivo de configuração personalizado do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar a aplicação Node.js para rodar no mesmo container
COPY --from=node-builder /home/qmunik2 /usr/src/app

# Instalar PM2 para gerenciar a aplicação Node.js
RUN apk add --no-cache nodejs npm && npm install -g pm2

# Expor portas para Nginx (80) e Node.js (3000)
EXPOSE 80 3000

# Comando para rodar Nginx e Node.js
CMD ["sh", "-c", "nginx && pm2-runtime /usr/src/app/app.js"]
