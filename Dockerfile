
FROM nginx:1.27-alpine

LABEL description="Jenkins Docker Nginx CI/CD Lab"

COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/style.css

EXPOSE 80
