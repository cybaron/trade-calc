#!/usr/bin/env ruby -Ku
require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.new("./db/records.sqlite3")

# 年間損益
puts "=== 年間損益  ==="
sql = <<SQL
  SELECT SUM(deliverymoney) AS price
  FROM(
  SELECT stockcode,stockname,deliverymoney
  FROM spot
  UNION ALL
  SELECT stockcode,stockname,deliverymoney
  FROM margine
  ) AS t
  ;
SQL
db.execute(sql) do |row|
  p row
end

# 年間損益(銘柄単位)
puts "=== 年間損益（銘柄単位）==="
sql = <<SQL
  SELECT stockcode,stockname,SUM(deliverymoney) AS price
  FROM(
  SELECT stockcode,stockname,deliverymoney
  FROM spot
  UNION ALL
  SELECT stockcode,stockname,deliverymoney
  FROM margine
  ) AS t
  GROUP BY stockcode
  ORDER BY price
  ;
SQL
db.execute(sql) do |row|
  p row
end
  
# 年間売買手数料
puts "=== 年間売買手数料 ==="
sql = <<SQL
  SELECT SUM(commission)+SUM(tax) AS price
  FROM(
  SELECT stockcode,stockname,commission,tax
  FROM spot
  UNION ALL
  SELECT stockcode,stockname,commission,tax
  FROM margine
  ) AS t
  ;
SQL
db.execute(sql) do |row|
  p row
end

# 月毎売買手数料
puts "=== 月毎売買手数料 ==="

# 年間金利
puts "=== 年間金利 ==="

# 金利（銘柄単位）
puts "=== 金利（銘柄単位） ==="
