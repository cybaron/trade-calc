#!/usr/bin/env ruby -Ku
require 'rubygems'
require 'csv'
require 'sqlite3'
require 'kconv'
require 'fixednumber'

spot = Array.new
margine = Array.new

#DBにテーブルを準備
#db = SQLite3::Database.new("./db/records.sqlite3")
db = SQLite3::Database.new("#{PATH_DB}")
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

if File.exist?("#{PATH_DATA_GENBUTSU}") then
  sql = "DELETE FROM spot;"
  db.execute(sql)
end

#現物CSVデータの読み込み
CSV.open("#{PATH_DATA_GENBUTSU}","r") do |row|
  next if row[2].to_i == 0  # CSVヘッダ部除外
  new_item = {
  :agreementdate => row[0].gsub(/\//,'-'),
  :agreementno => row[1],
  :stockcode => row[2],
  :stockname => row[3].toutf8,
  :exchangedivision => row[4].toutf8,
  :tradedivision => row[5].toutf8,
  :market => row[6].toutf8,
  :account => row[7].toutf8,
  :agreementamount => row[8],
  :agreementprice => row[9],
  :commission => row[10],
  :commissiontax => row[11],
  :deliverymoney => row[12],
  :deliveryday => row[13].gsub(/\//,'-')
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

if File.exist?("#{PATH_DATA_SHINYO}") then
  sql = "DELETE FROM margine;"
  db.execute(sql)
end

#信用取引CSVデータの読み込み
CSV.open("#{PATH_DATA_SHINYO}","r") do |row|
  next if row[2].to_i == 0  # CSVヘッダ部除外
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
