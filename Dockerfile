
# Use official lightweight Nginx image
FROM nginx:alpine

# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy website HTML
COPY index.html /usr/share/nginx/html/index.html

# Copy website CSS
COPY style.css /usr/share/nginx/html/style.css

# Copy professional profile photo
COPY profile.jpg /usr/share/nginx/html/profile.jpg

# Expose HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
