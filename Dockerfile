FROM ruby:2.5.1

ENV BUNDLER_VERSION=1.17.3

# Configurar diretório de trabalho
WORKDIR /app

# Cria o diretório .ssh no container
RUN mkdir -p /root/.ssh

# Define as permissões corretas
RUN chmod 700 /root/.ssh

# Copiar Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar gems
RUN gem install bundler -v '1.17.3' 
RUN bundle install

# Copiar todo o projeto
COPY . ./

ENTRYPOINT [ "./entrypoints/docker-entrypoint.sh" ]