#!/usr/bin/env ruby -Ku
require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.new("./db/records.sqlite3")

# 年間損益(銘柄単位)
puts "=== 年間損益（銘柄単位）==="
sql = "
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
  ;"
db.execute(sql) do |row|
  p row
end
  

# 月毎売買手数料
puts "=== 月毎売買手数料 ==="
