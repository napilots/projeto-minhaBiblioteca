# 📚 Aplicativo de Biblioteca

Este projeto utiliza uma arquitetura de Monorepo, separando o aplicativo visual da API de dados.

## 📁 Estrutura de Pastas

* **/frontend:** Contém o código-fonte do aplicativo desenvolvido em Flutter/Dart. Aqui fica toda a interface do usuário (UI) e a lógica de apresentação.
* **/backend:** (Em desenvolvimento) Conterá a API construída em Node.js com TypeScript e a conexão com o banco de dados MongoDB.

## 🛠️ Tecnologias Utilizadas
* Flutter & Dart
* Docker

### Frontend: Aplicação Web (Flutter/Dart) com Docker

Para containerizar e executar a interface da aplicação localmente:

1. **Pré-requisito:** Certifique-se de ter o **Docker Desktop** instalado e rodando na sua máquina (https://www.docker.com/products/docker-desktop).

2. **Construa a imagem Docker**:
   - No terminal, navegue até a pasta do frontend: 
     `cd frontend`
   - Execute o comando para construir a imagem (não esqueça do ponto final): 
     `docker build -t library-app-frontend .`

3. **Execute o contêiner**:
   - Inicie o contêiner em segundo plano mapeando a porta local: 
     `docker run -d -p 8080:80 --name frontend-container library-app-frontend`
   - Acesse **http://localhost:8080** no seu navegador para utilizar o aplicativo.

*Nota: Este processo cria uma imagem otimizada que constrói a aplicação Flutter e utiliza o Nginx para servir os arquivos estáticos.*

