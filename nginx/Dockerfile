FROM nginx:alpine

# Install bash
RUN apk update && apk add bash
COPY ./default.template.conf /etc/nginx/templates/nginx.conf.template
COPY ./ssl /etc/nginx/ssl

RUN rm /etc/nginx/conf.d/default.conf
