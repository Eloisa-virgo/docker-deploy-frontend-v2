#!/bin/sh
set -e

# 兜底默认后端地址
VITE_GRAPHQL_URI="${VITE_GRAPHQL_URI:-http://54.226.106.43:8082/graphql}"
VITE_SERVER_URI="${VITE_SERVER_URI:-http://54.226.106.43:8082}"

# 替换占位符（# 做分隔符，避免URL符号冲突）
find /usr/share/nginx/html/assets -name '*.js' -exec sed -i \
"s#__VITE_GRAPHQL_URI_PLACEHOLDER__#${VITE_GRAPHQL_URI}#g" {} +

find /usr/share/nginx/html/assets -name '*.js' -exec sed -i \
"s#__VITE_SERVER_URI_PLACEHOLDER__#${VITE_SERVER_URI}#g" {} +

# 打印配置用于课堂演示
echo "=== Runtime Backend Config ==="
echo "GraphQL API: $VITE_GRAPHQL_URI"
echo "Server URI:  $VITE_SERVER_URI"
echo "=============================="

# 前台启动Nginx
exec nginx -g 'daemon off;'