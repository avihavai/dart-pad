FROM google/dart:2.8

WORKDIR /app

# Install Node and Vulcanize
RUN apt-get update && apt-get install -y curl software-properties-common unzip
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN npm install -g vulcanize

COPY . /app/dart-pad

# Replace localhost with 0.0.0.0 for docker compatibility
RUN sed -i 's/localhost/0.0.0.0/g' dart-pad/bin/serve.dart

RUN pub global activate grinder

RUN cd dart-pad && pub get && pub get --offline

# Define and expose backend port
ENV DARTPAD_BACKEND=http://0.0.0.0:8082
EXPOSE 8000

COPY entrypoint.sh .
CMD ["./entrypoint.sh"]
