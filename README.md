# MercadoPago SDK module for Payments integration

* [Usage](#usage)
* [Using MercadoPago Checkout](#checkout)
* [Using MercadoPago Payment collection](#payments)

<a name="usage"></a>
## Usage:

1. Copy this files below, to your project desired folder:
	
* lib/mercadopago.asp
* lib/JSON_2.0.4.asp
* lib/json2.asp


* Get your **CLIENT_ID** and **CLIENT_SECRET** in the following address:
	* Argentina: [https://www.mercadopago.com/mla/herramientas/aplicaciones](https://www.mercadopago.com/mla/herramientas/aplicaciones)
	* Brazil: [https://www.mercadopago.com/mlb/ferramentas/aplicacoes](https://www.mercadopago.com/mlb/ferramentas/aplicacoes)
	* Mexico: [https://www.mercadopago.com/mlm/herramientas/aplicaciones](https://www.mercadopago.com/mlm/herramientas/aplicaciones)
	* Venezuela: [https://www.mercadopago.com/mlv/herramientas/aplicaciones](https://www.mercadopago.com/mlv/herramientas/aplicaciones)

```aspx

<!--#include file="lib\mercadopago.asp"-->
<!--#include file="lib\JSON_2.0.4.asp"-->
<!--#include file="lib\json2.asp"-->
<%
	Dim mp
	
	Set mp = new Mercadopago
	
	mp.construct "CLIENT_ID", "CLIENT_SECRET"
%>
```

### Get your Access Token:

```aspx
<%
	Dim accessToken

	accessToken = mp.get_access_token()

	Response.write (accessToken)
%>
```

<a name="checkout"></a>
## Using MercadoPago Checkout

### Get an existent Checkout preference:

```aspx
<%
	Dim preferenceResult

	preferenceResult =  mp.get_preference(PREFERENCE_ID)

	Response.write (preferenceResult)
%>
```

### Create a Checkout preference:

```aspx
<%
	Dim o
	Dim var_json	
	
	Set o = jsObject()
	Set o("items") = jsArray()
	Set o("items")(Null) = jsObject()

		o("items")(Null)("id") = "Product ID"
		o("items")(Null)("title") = "Product Name"
		o("items")(Null)("description") = "Description"
		o("items")(Null)("quantity") = 1
		o("items")(Null)("unit_price") = 50.5
		o("items")(Null)("currency_id") = "BRL"
		o("items")(Null)("picture_url") = ""
		o("external_reference")="Your_control_id"

	Set o("payer") = jsObject()
		o("payer")("name") = "payer-name"
		o("payer")("surname") = "payer-surname"
		o("payer")("email") = "payer@email.com"
	
	Set o("back_urls") = jsObject()
		o("back_urls")("success") = ""
		o("back_urls")("failure") = ""
		o("back_urls")("pending") = ""
	
	Set o("payment_methods") = jsObject()
	Set	o("payment_methods")("excluded_payment_methods") = jsArray()
	Set	o("payment_methods")("excluded_payment_methods")(Null) = jsObject()
		
		o("payment_methods")("excluded_payment_methods")(Null)("id")="amex"
		
	Set	o("payment_methods")("excluded_payment_types") = jsArray()
	Set	o("payment_methods")("excluded_payment_types")(Null) = jsObject()
		
		o("payment_methods")("excluded_payment_types")(Null)("id")="ticket"
		o("payment_methods")("installments") = 12
	
    var_json =  o.jsString
	
	Dim mp
	Dim response
	Set mp = new Mercadopago
	
	mp.construct "CLIENT_ID", "CLIENT_SECRET"	
	response=mp.create_preference(var_json)
	
	'Decode JSON - Create Preference	
	Dim objJSON,preferenceResult 
	Set objJSON = JSON
	Set preferenceResult = objJSON.parse(join(array(response)))
	
	' Preference with SANDBOX - > preferenceResult.sandbox_init_point
	' Preference -> preferenceResult.init_point
		
%>
```
<a href="http://developers.mercadopago.com/documentacao/receber-pagamentos#glossary">Others items to use</a>

### Update an existent Checkout preference:

```aspx
<%
	Dim o
	Dim var_json	
	
	Set o = jsObject()
	Set o("items") = jsArray()
	Set o("items")(Null) = jsObject()

		o("items")(Null)("title") = "Test Modified"
		o("items")(Null)("quantity") = 1
		o("items")(Null)("unit_price") = 80.5
		o("items")(Null)("currency_id") = "BRL"
		
	var_json =  o.jsString
	
	Dim preferenceResult
	
	preferenceResult=mp.update_preference(PREFERENCE_ID,var_json)
	
	Response.write (preferenceResult)
%>	
```

<a name="payments"></a>
## Using MercadoPago Payment

###Searching:

```aspx
<%
	Dim payment_info
	Dim strSearch,site_id,external_reference

	id = "00000"
	external_reference = "Reference_1234"
	
	strSearch = "id="& site_id & "&external_reference=" & external_reference 

	payment_info = mp.search_payment(strSearch,null,null)
	
	Response.write( "<br>" & payment_info & "<br><br>")
%>
```
<a href="http://developers.mercadopago.com/documentacao/busca-de-pagamentos-recebidos">More search examples</a>
### Receiving IPN notification:

* Go to **Mercadopago IPN configuration**:
	* Argentina: [https://www.mercadopago.com/mla/herramientas/notificaciones](https://www.mercadopago.com/mla/herramientas/notificaciones)
	* Brasil: [https://www.mercadopago.com/mlb/ferramentas/notificacoes](https://www.mercadopago.com/mlb/ferramentas/notificacoes)<br />
	* Mexico: [https://www.mercadopago.com/mlm/herramientas/notificaciones](https://www.mercadopago.com/mlm/herramientas/notificaciones)
	* Venezuela: [https://www.mercadopago.com/mlv/herramientas/notificaciones](https://www.mercadopago.com/mlv/herramientas/notificaciones)

```aspx
<!--#include file="lib\mercadopago.asp"-->
<!--#include file="lib\json2.asp"-->
<%

	Dim payment_info
	Dim id
	
	Dim mp
	Set mp = new Mercadopago
	
	mp.construct "CLIENT_ID", "CLIENT_SECRET"
	
	id = Request.Querystring("id")
   ' Get the payment reported by the IPN. Glossary of attributes response in https://developers.mercadopago.com
	
	if id <>  "" then	
	
		payment_info = mp.get_payment_info(id)
	
		Response.write( "<br>" & payment_info & "<br><br>")
		
		Dim objJSON,retJSON 
	
		Set objJSON = JSON
		Set retJSON = objJSON.parse(join(array(payment_info)))
	
		Response.write( " **** DECODE JSON **** <BR><BR> ")
		Response.write( " - id :" & retJSON.collection.id  & "<br>"  )
		Response.write( " - external_reference :" & retJSON.collection.external_reference  & "<br>" )
		Response.write( " - status : " & retJSON.collection.status  & "<br>"  )
		Response.write( " - payment_type : " & retJSON.collection.payment_type  & "<br>"  )
	
	else
		
		Response.write( " **** ID = " & id & " Null **** <BR><BR> ")
	
	end if
%>
```

### Cancel (only for pending payments):

```aspx
<%
	Dim result

	result =  mp.cancel_payment(Request.Querystring("id"))

	Response.write (result)
%>
```

### Refund (only for accredited payments):

```aspx
<%
	Dim result

	result =  mp.refund_payment(Request.Querystring("id"))

	Response.write (result)
%>
```
<a href="http://developers.mercadopago.com/documentacao/devolucao-e-cancelamento">About Cancel & Refund </a>
