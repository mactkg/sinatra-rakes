require 'rack'
require 'mysql2'
require 'table_print'
tp.set :max_width, 40

APP_CLASS = Rack::Builder.parse_file('config.ru').first.settings
# or
# require_relative 'app.rb'
# APP_CLASS = App

top_level = self
using Module.new {
  refine(top_level.singleton_class) do
    def db
      @db ||= Mysql2::Client.new(
        host: ENV.fetch('DATABASE_HOST', 'localhost'),
        port: ENV.fetch('DATABASE_PORT', 3306),
        username: ENV.fetch('DATABASE_USERNAME', 'root'),
        password: ENV.fetch('DATABASE_PASSWORD', ''),
        database: ENV.fetch('DATABASE_NAME', 'isucon5q')
      )
    end
  end
}

desc "ルーティングを表示する"
task :routes do
  routes = APP_CLASS.routes.flat_map { |action, route_ary|
    route_ary.flat_map { |route|
      { route: route.first, action: action }
    }
  }.group_by { |r|
    r[:route].safe_string
  }

  routes.keys.sort.each do |k|
    routes[k].each do |route|
      puts "#{route[:action]} #{k}"
    end
  end
end

namespace :db do
  desc "テーブル情報をあつめる"
  task :schema do
    client = db

    tables = client.query("show tables").flat_map(&:values)

    tables.each do |table|
      # No use statement is too bad but #prepare cause Mysql2::Error
      structure = client.query("desc #{table}")
      index = client.query("show index from #{table}")

      puts "\n\n=== #{table.upcase} ===\n"
      tp structure.to_a
      puts
      tp index.to_a
    end
  end

  desc "設定を表示"
  task :settings do
    client = db
    innodb = client.query("SHOW GLOBAL VARIABLES LIKE 'innodb_buffer_pool_%'")
    query = client.query("SHOW GLOBAL VARIABLES LIKE '%query%'")

    tp innodb.to_a
    puts
    tp query.to_a
  end
end
