# Use a imagem do Flutter para construir a aplicação
FROM cirrusci/flutter:latest AS build

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos de dependências
COPY pubspec.yaml ./

# Instale as dependências
RUN flutter pub get

# Copie o resto do código
COPY . .

# Construa a aplicação para web
RUN flutter build web --release

# Use nginx para servir os arquivos estáticos
FROM nginx:alpine

# Copie os arquivos construídos para o nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Exponha a porta 80
EXPOSE 80

# Comando para iniciar o nginx
CMD ["nginx", "-g", "daemon off;"]