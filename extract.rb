#!/usr/bin/env ruby -Ku
require 'rubygems'
require 'sqlite3'
require 'kconv'
require 'fixednumber'

$KCODE = 'UTF8'

class Integer
  def to_c
    str = to_s
    tmp = ""
    while(str =~ /([-+]?.*\d)(\d\d\d)/) do
      str = $1
      tmp = ",#{$2}" + tmp
    end
    str + tmp
  end
end

db = SQLite3::Database.new("#{PATH_DB}")

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
  printf("%s\n", row[0].to_i.to_c)
end

# 月別損益
puts "=== 月別損益 ==="
sql = <<SQL
  SELECT strftime('%Y-%m',agreementdate) AS month,SUM(deliverymoney)
  FROM(
  SELECT agreementdate,stockcode,stockname,deliverymoney
  FROM spot
  UNION ALL
  SELECT agreementdate,stockcode,stockname,deliverymoney
  FROM margine
  ) AS t
  GROUP BY month
  ;
SQL
db.execute(sql) do |row|
  printf("%s %15s\n", row[0], row[1].to_i.to_c)
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
  printf("%4d", row[0])
  print(sprintf("|%-*s|",63 + row[1].length - row[1].tosjis.length, row[1]))
  printf("%10s|\n", row[2].to_i.to_c)
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
  printf("%15s\n", row[0].to_i.to_c)
end

# 月毎売買手数料
puts "=== 月毎売買手数料 ==="
sql = <<SQL
  SELECT strftime('%Y-%m',agreementdate) AS month,
    SUM(commission)+SUM(commissiontax) AS price
  FROM(
  SELECT agreementdate,stockcode,stockname,commission,commissiontax
  FROM spot
  UNION ALL
  SELECT agreementdate,stockcode,stockname,commission,commissiontax
  FROM margine
  ) AS t
  GROUP BY month
SQL
db.execute(sql) do |row|
  printf("%s %10s\n", row[0], row[1].to_i.to_c)
end

# 年間買方金利・貸株料
puts "=== 年間 買方金利・貸株料 ==="
sql = <<SQL
  SELECT SUM(rates),SUM(lendprice)
  FROM margine
SQL
db.execute(sql) do |row|
  printf("%10s %10s\n", row[0].to_i.to_c, row[1].to_i.to_c)
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
  printf("%4d", row[0])
  print(sprintf("|%-*s|",63 + row[1].length - row[1].tosjis.length, row[1]))
  printf("%10s|%10s|\n", row[2].to_i.to_c, row[3].to_i.to_c)
end

db.close
