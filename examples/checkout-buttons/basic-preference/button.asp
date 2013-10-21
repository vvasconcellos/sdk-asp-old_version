<!--#include file="../../../lib/mercadopago.asp"-->
<!--#include file="../../../lib/JSON_2.0.4.asp"-->
<!--#include file="../../../lib/json2.asp"-->
<html>
    <head>
        <title>MercadoPago SDK - Create Preference and Show Checkout Example</title>
    </head>
    <body>

<%	
    Dim o
	Dim var_json	
	
	Set o = jsObject()
	Set o("items") = jsArray()
	Set o("items")(Null) = jsObject()

		o("items")(Null)("id") = "Codigo"
		o("items")(Null)("title") = "Nome Produto"
		o("items")(Null)("description") = "Descricao"
		o("items")(Null)("quantity") = 1
		o("items")(Null)("unit_price") = 50.5
		o("items")(Null)("currency_id") = "BRL"
		o("items")(Null)("picture_url") = ""
		o("external_reference")="Reference_1234"

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
			
	mp.construct "client id", "client secret"	
	response=mp.create_preference(var_json)
	
	'Decode JSON - Create Preference	
	Dim objJSON,preferenceResult 
	Set objJSON = JSON
	Set preferenceResult = objJSON.parse(join(array(response)))
	
	' URL for create preference with SANDBOX - > preferenceResult.sandbox_init_point
	' URL for create preference -> preferenceResult.init_point
		
%>
       	<a href="<% response.write preferenceResult.init_point  %>" name="MP-Checkout" class="blue-m-Ov-Ar-BrAll" mp-mode="modal" >Pagar</a>
        <script type="text/javascript">
		
	(function(){function $MPBR_load(){window.$MPBR_loaded !== true && (function(){var s = document.createElement("script");s.type = "text/javascript";s.async = true;
	s.src = ("https:"==document.location.protocol?"https://www.mercadopago.com/org-img/jsapi/mptools/buttons/":"http://mp-tools.mlstatic.com/buttons/")+"render.js";
	var x = document.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);window.$MPBR_loaded = true;})();}
	window.$MPBR_loaded !== true ? (window.attachEvent ? window.attachEvent('onload', $MPBR_load) : window.addEventListener('load', $MPBR_load, false)) : null;})();
	</script>
    </body>
</html>
