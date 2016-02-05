class DashboardController < ApplicationController

  def getData

    @json_data = JSON.parse(Net::HTTP.get(URI.parse('http://95.85.12.99:6543/category/'+params[:cat_name]+'/product/'+params[:id])))['product']
    
    #@json_data = JSON.parse('{"date_modified": {"$date": 1451741150716}, "category": "CPU-koelers", "ean": "4260120532850", "Productcode": "TTC-NK85TZ", "_id": {"$oid": "5687c1ce0b5f962489007c20"}, "brand": "Titan", "records": [], "Toegevoegd aan prijsvergelijker": "vrijdag 5 juni 2009",
    #  "records": [
    #      {"price" : "183.95", "webshop" : "Afuture", "date": "03/01/2016 18:00" }, {"price" : "165.50", "webshop" : "Computerland", "date" :"03/01/2016 18:00" },          {"price" : "172.50", "webshop" : "Azerty", "date" :"03/01/2016 18:00" },          {"price" : "184.95", "webshop" : "Afuture", "date" : "01/01/2016 18:00" },          {"price" : "172.50", "webshop" : "Azerty", "date" : "01/01/2016 18:00" },          {"price" : "168.55", "webshop" : "Computerland", "date" :"01/01/2016 18:00" },          {"price" : "172.95", "webshop" : "Azerty", "date" :"02/01/2016 18:00" },          {"price" : "184.95", "webshop" : "Afuture", "date" :"02/01/2016 18:00" },          {"price" : "168.00", "webshop" : "Computerland", "date" :"02/01/2016 18:00" },          {"price" : "172.50", "webshop" : "Azerty", "date": "06/01/2016 18:00" },          {"price" : "164.50", "webshop" : "Computerland", "date" :"06/01/2016 18:00" },          {"price" : "179.95", "webshop" : "Afuture", "date": "06/01/2016 18:00" },          {"price" : "172.50", "webshop" : "Azerty", "date" :"07/01/2016 18:00" },          {"price" : "104.50", "webshop" : "Afuture", "date" :"07/01/2016 18:00" },          {"price" : "168.95", "webshop" : "Computerland", "date" :"07/01/2016 18:00" },          {"price" : "172.50", "webshop" : "Azerty", "date" :"04/01/2016 18:00" },          {"price" : "180.95", "webshop" : "Afuture", "date" :"04/01/2016 18:00" },          {"price" : "165.50", "webshop" : "Computerland", "date": "04/01/2016 18:00" },          {"price" : "172.50", "webshop" : "Azerty", "date": "05/01/2016 18:00" },          {"price" : "180.95", "webshop" : "Afuture", "date" :"05/01/2016 18:00" },          {"price" : "165.50", "webshop" : "Computerland", "date" :"05/01/2016 18:00" }          ],
    #{}"name": "Fenrir i7"}')

    render json: @json_data
  end
end
