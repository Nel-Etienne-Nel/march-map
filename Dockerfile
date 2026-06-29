FROM nginx:alpine

# App files
COPY index.html /usr/share/nginx/html/index.html

# Railway injects $PORT at runtime; nginx's entrypoint renders any
# *.template files in this dir through envsubst into /etc/nginx/conf.d/
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Only substitute ${PORT} in templates, leaving nginx vars like $uri intact
ENV NGINX_ENVSUBST_FILTER=PORT

# Default for local `docker run`; Railway overrides this
ENV PORT=80
EXPOSE 80
