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
  SELECT SUM(commission)+SUM(commissiontax) AS price
  FROM(
  SELECT stockcode,stockname,commission,commissiontax
  FROM spot
  UNION ALL
  SELECT stockcode,stockname,commission,commissiontax
  FROM margine
  ) AS t
  ;
SQL
db.execute(sql) do |row|
  p row
end

# 月毎売買手数料
puts "=== 月毎売買手数料 ==="

# 年間買方金利・貸株料
puts "=== 年間 買方金利・貸株料 ==="
sql = <<SQL
  SELECT SUM(rates),SUM(lendprice)
  FROM margine
SQL
db.execute(sql) do |row|
  p row
end

# 買方金利・貸株料（銘柄単位）
puts "=== 買方金利・貸株料（銘柄単位） ==="
sql = <<SQL
  SELECT stockcode,stockname,SUM(rates),SUM(lendprice)
  FROM margine
  GROUP BY stockcode
  ORDER BY stockcode
SQL
db.execute(sql) do |row|
  p row
end
