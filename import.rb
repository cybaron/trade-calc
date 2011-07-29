require 'rubygems'
require 'sqlite3'
require 'csv'

spot = Array.new
margine = Array.new

#現物CSVデータの読み込み
#約定日時,約定番号,銘柄コード,銘柄名,取引区分,売買区分,市場,口座,約定数量,約定単価,手数料,手数料消費税,受渡金額,受渡日
CSV.open("./data/torihikiGenbutsu.csv","r") do |row|
  spot << row
end

spot.each do |one|
  agreementdate = one[0]
  agreementno = one[1]
  stockcode = one[2]
  stockname = one[3]
  exchangedivision = one[4]
  tradedivision = one[5]
  market = one[6]
  account = one[7]
  amount = one[8]
  agreementprice = one[9]
  commission = one[10]
  tax = one[11]
  deliverymoney = one[12]
  deliveryday = one[13]
end

#信用取引CSVデータの読み込み
#約定日時,約定番号,銘柄コード,銘柄名,取引区分,売買区分,市場,口座,信用区分,約定数量,約定単価,手数料,手数料消費税,建数量,建単価,新規手数料,新規手数料消費税,管理費,名義書換料,金利,貸株料,品貸料,受渡金額,受渡日
CSV.open("./data/torihikiShinyo.csv","r") do |row|
  margine << row
end

spot.each do |one|
  puts one.join(",")
end

#sqlite3.dbにデータ挿入

#終了
