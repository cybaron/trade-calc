#!/usr/bin/env ruby -Ku
require 'rubygems'
require 'csv'
require 'sqlite3'
require 'kconv'

spot = Array.new
margine = Array.new

#DBにテーブルを準備
db = SQLite3::Database.new("./db/records.sqlite3")
unless(db.execute("SELECT tbl_name FROM sqlite_master WHERE type == 'table'").flatten.include?("spot"))
  sql = "CREATE TABLE spot(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  agreementdate,
  agreementno,
  stockcode,
  stockname,
  exchangedivision,
  tradedivision,
  market,
  account,
  agreementamount,
  agreementprice,
  commission,
  commissiontax,
  deliverymoney,
  deliveryday
  );"
  db.execute(sql)
end

unless(db.execute("SELECT tbl_name FROM sqlite_master WHERE type == 'table'").flatten.include?("margine"))
  sql = "CREATE TABLE margine(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  agreementdate,
  agreementno,
  stockcode,
  stockname,
  exchangedivision,
  tradedivision,
  market,
  account,
  margindivision,
  amount,
  agreementprice,
  commission,
  commissiontax,
  agreementamount,
  price,
  newcommission,
  newcommissiontax,
  managementcost,
  transferprice,
  rates,
  lendprice,
  stockprice,
  deliverymoney,
  deliveryday
  );"
  db.execute(sql)
end

#現物CSVデータの読み込み
#約定日時,約定番号,銘柄コード,銘柄名,取引区分,売買区分,市場,口座,約定数量,約定単価,手数料,手数料消費税,受渡金額,受渡日
CSV.open("./data/torihikiGenbutsu.csv","r") do |row|
#CSV.open("./data/sample.csv","r") do |row|
  spot << row
end

sql = "DELETE FROM spot;"
db.execute(sql)

spot.each do |one|
  new_item = {
  :agreementdate => one[0].gsub(/\//,'-'),
  :agreementno => one[1],
  :stockcode => one[2],
  :stockname => one[3].toutf8,
  :exchangedivision => one[4].toutf8,
  :tradedivision => one[5].toutf8,
  :market => one[6].toutf8,
  :account => one[7].toutf8,
  :agreementamount => one[8],
  :agreementprice => one[9],
  :commission => one[10],
  :commissiontax => one[11],
  :deliverymoney => one[12],
  :deliveryday => one[13].gsub(/\//,'-')
  }

  sql = "INSERT INTO spot VALUES(
  :id,
  :agreementdate,
  :agreementno,
  :stockcode,
  :stockname,
  :exchangedivision,
  :tradedivision,
  :market,
  :account,
  :agreementamount,
  :agreementprice,
  :commission,
  :commissiontax,
  :deliverymoney,
  :deliveryday
  )"
  
  db.execute(sql, new_item)
end

sql = "DELETE FROM margine;"
db.execute(sql)

#信用取引CSVデータの読み込み
#約定日時,約定番号,銘柄コード,銘柄名,取引区分,売買区分,市場,口座,信用区分,約定数量,約定単価,手数料,手数料消費税,建数量,建単価,新規手数料,新規手数料消費税,管理費,名義書換料,金利,貸株料,品貸料,受渡金額,受渡日
CSV.open("./data/torihikiShinyo.csv","r") do |row|
#  margine << row
  new_item = {
  :agreementdate => row[0].gsub(/\//,'-'),
  :agreementno => row[1],
  :stockcode => row[2],
  :stockname => row[3].toutf8,
  :exchangedivision => row[4].toutf8,
  :tradedivision => row[5].toutf8,
  :market => row[6].toutf8,
  :account => row[7].toutf8,
  :margindivision => row[8].toutf8,
  :agreementamount => row[9],
  :agreementprice => row[10],
  :commission => row[11],
  :commissiontax => row[12],
  :amount => row[13],
  :price => row[14],
  :newcommission => row[15],
  :newcommissiontax => row[16],
  :managementcost => row[17],
  :transferprice => row[18],
  :rates => row[19],
  :lendprice => row[20],
  :stockprice => row[21],
  :deliverymoney => row[22],
  :deliveryday => row[23].gsub(/\//,'-')
  }

  sql = "INSERT INTO margine VALUES(
  :id,
  :agreementdate,
  :agreementno,
  :stockcode,
  :stockname,
  :exchangedivision,
  :tradedivision,
  :market,
  :account,
  :margindivision,
  :agreementamount,
  :agreementprice,
  :commission,
  :commissiontax,
  :amount,
  :price,
  :newcommission,
  :newcommissiontax,
  :managementcost,
  :transferprice,
  :rates,
  :lendprice,
  :stockprice,
  :deliverymoney,
  :deliveryday
  );"

  db.execute(sql, new_item)
end

db.close
#終了
