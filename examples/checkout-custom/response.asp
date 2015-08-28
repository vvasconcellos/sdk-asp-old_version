<!--#include file="../../lib/mercadopago.asp"-->
<!--#include file="../../lib/JSON_2.0.4.asp"-->
<!--#include file="../../lib/json2.asp"-->
<html>
    <head>
        <title>MercadoPago SDK - Create Checkout Custom and Show Checkout Example</title>
    </head>
    <body>

<%	
    Dim o
	Dim var_json	
	
	Set o = jsObject()
	
	o("amount") = CDbl(request.form("amount"))
	o("installments") =  CInt(request.form("installmentsOption"))
    o("payment_method_id") =  request.form("paymentMethod")
    o("currency_id") =  "BRL"
    o("card_token_id") =  request.form("card_token_id") 
    o("external_reference") =  "my_order_1234"
	
	
	Set o("items") = jsArray()
	Set o("items")(Null) = jsObject()

		o("items")(Null)("id") = "Codigo"
		o("items")(Null)("title") = "Nome Produto"
		o("items")(Null)("description") = "Descricao"
		o("items")(Null)("quantity") = 1
		o("items")(Null)("unit_price") = 50.5
		o("items")(Null)("currency_id") = "BRL"
		o("items")(Null)("picture_url") = ""


	Set o("customer") = jsObject()
		o("customer")("first_name") = "payer-name"
		o("customer")("last_name") = "payer-surname"
		o("customer")("email") = "test_user_732138@testuser.com"
	
	Set o("customer")("phone") = jsObject()
		o("customer")("phone")("area_code") = "011"
		o("customer")("phone")("number") = "38882377"
		
	Set o("customer")("identification") = jsObject()
		o("customer")("identification")("type") = "CPF"
		o("customer")("identification")("number") = "19119119100"
		
	Set o("customer")("address") = jsObject()
		o("customer")("address")("zip_code") = "06541005"
		o("customer")("address")("street_name") = "Street name"
		o("customer")("address")("street_number") = 123
		
	o("customer")("registration_date") = "2014-06-28T16:53:03.176-04:00"
	
	Set o("shipments") = jsObject()
	Set o("shipments")("receiver_address") = jsObject()
		o("shipments")("receiver_address")("zip_code") = "06541005"
		o("shipments")("receiver_address")("street_name") = "Street name"
		o("shipments")("receiver_address")("street_number") = 123
		o("shipments")("receiver_address")("floor") = "5"
		o("shipments")("receiver_address")("apartment") = "C"
	
    var_json =  o.jsString
	
	response.write var_json

	Dim mp
	Dim response_json
	Set mp = new Mercadopago
			
	mp.construct "client_id", "client_secret"	
	response_json=mp.create_checkout_custom(var_json)
	
	response.write response_json
	
	'Decode JSON - Create Checkout Custom	
	Dim objJSON,preferenceResult 
	Set objJSON = JSON
	Set preferenceResult = objJSON.parse(join(array(response_json)))
	
	'example get information
	'Payment status -> preferenceResult.status
	
	response.write "<h3>" & preferenceResult.status & "</h3>"
	
%>
       
    </body>
</html>
