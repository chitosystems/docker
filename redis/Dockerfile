ARG REDIS_TAG
FROM redis:${REDIS_TAG}
ARG REDIS_PASSWORD

# Create the redis configuration directory if it doesn't exist
RUN mkdir -p /usr/local/etc/redis

# Copy the configuration file into the image
COPY redis.conf /usr/local/etc/redis/redis.conf

# Update the configuration file with the provided password
RUN sed -i "s/requirepass yourStrongPassword/requirepass ${REDIS_PASSWORD}/" /usr/local/etc/redis/redis.conf

# Use a non-root user to run Redis
USER redis

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
