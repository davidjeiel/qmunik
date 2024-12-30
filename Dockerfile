# Etapa 1: Construção da aplicação usando Node.js
FROM node:18 AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos de configuração e dependências
COPY package*.json ./

# Instala as dependências
RUN npm install

# Copia os arquivos do projeto para o diretório de trabalho
COPY . .

# Realiza o build da aplicação com o Vite
RUN npm run build

# Etapa 2: Servir os arquivos estáticos com NGINX
FROM nginx:alpine

# Remove os arquivos padrão do NGINX
RUN rm -rf /usr/share/nginx/html/*

# Copia os arquivos estáticos gerados pelo Vite para o diretório padrão do NGINX
COPY --from=build /app/dist /usr/share/nginx/html

# Exponha a porta 80 para acesso
EXPOSE 3030

# Comando padrão para iniciar o NGINX
CMD ["nginx", "-g", "daemon off;"]
