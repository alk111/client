# Specify the base image
FROM node:14 as builder

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the source code
COPY . .

# Build the AngularJS app
RUN npm run build

# Use a smaller base image for production
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
# Copy the build files from the builder stage to the production stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose the port used by Nginx
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
