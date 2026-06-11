# 构建阶段
FROM node:22.14-alpine3.20 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# 编译注入占位符
RUN VITE_GRAPHQL_URI=__VITE_GRAPHQL_URI_PLACEHOLDER__ \
    VITE_SERVER_URI=__VITE_SERVER_URI_PLACEHOLDER__ \
    npm run build -- --mode production

# 生产Nginx阶段
FROM nginx:1.27.0-alpine AS production-stage
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 动态地址替换脚本
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]