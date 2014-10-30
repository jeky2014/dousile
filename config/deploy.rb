require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)


set :domain, 'dousile.com' # 登录主机
set :user, 'root' # 登录用户
set :deploy_to, '/opt/web/www.dousile.com' # 部署目录，结尾不带反斜杠
set :repository, 'https://github.com/jeky2014/dousile.git' # 源码路径
set :timestamp, Time.now.strftime("%Y%m%d_%H%M%S")
set :bundle, '/usr/local/bin/ruby-2.1.3/bin/bundle' # 服务器 bundle 位置


# 初始化新目录结构
task :new do
  queue "echo '开始创建网站目录结构'"
  queue "mkdir -p #{deploy_to}"
  queue "mkdir -p #{deploy_to}/shared/logs"
  queue "mkdir -p #{deploy_to}/release"
  
  queue "echo '开始获取最新源码'"
  queue "cd #{deploy_to}/release"
  queue "git clone #{repository} latest"

end

# 部署网站
task :deploy do
  queue "echo '开始获取最新源码'"
  queue "cd #{deploy_to}/release/latest"
  queue "git fetch origin master"
  
  queue "echo '将最新源码复制到新目录'"
  queue "cp -R #{deploy_to}/release/latest #{deploy_to}/release/#{timestamp}"
  
  queue "echo '设置权限及获取新包'"
  queue "cd #{deploy_to}/release/#{timestamp}"
  queue "chmod -R 777 ./*"
  queue "#{bundle} install"
  queue "rm -rf #{deploy_to}/current" # 删除软链接
  queue "ln -sf #{deploy_to}/release/#{timestamp} #{deploy_to}/current" # 软链接到最新版本
  queue "echo '最新存储目录：#{deploy_to}/release/#{timestamp}'"
end

# 重启服务器
task :reload do
  queue "echo '开始重启 nginx'"
  queue "/opt/nginx/sbin/nginx -s reload"
  queue "echo '重启 nginx 成功'"
end


# 部署、重启
task :deploy_reload do
  invoke :deploy
  invoke :reload
end



