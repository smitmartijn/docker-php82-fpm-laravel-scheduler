FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
  libmcrypt-dev \
  libicu-dev \
  git \
  curl \
  libpng-dev \
  libonig-dev \
  libxml2-dev \
  lsb-release \
  zip \
  libzip-dev \
  unzip \
  wget \
  ca-certificates \
  cron \
  gnupg \
  nano

# Install Docker client
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install docker-ce-cli -y

# Install NodeJS
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install nodejs -y

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip calendar intl

# Set working directory
WORKDIR /var/www

# Start cron
CMD ["php", "artisan", "schedule:work"]
