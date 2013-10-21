<!--#include file="../../lib/mercadopago.asp"-->
<!--#include file="../../lib/JSON_2.0.4.asp"-->
<!--#include file="../../lib/json2.asp"-->
<html>
    <head>
        <title>MercadoPago SDK - Create Preapproval Payment and Show Subscription Example</title>
    </head>
    <body>

<%	
    Dim o
	Dim var_json	
	
	Set o = jsObject()
	
	o("payer_email")="victor@teste.com"
	o("back_url")="http://54.232.203.124/mercadopago/"
	o("reason")="Monthly subscription to premium package"
	o("external_reference")="OP-1234"
	
	Set o("auto_recurring") = jsObject()
	o("auto_recurring")("frequency") = 1
	o("auto_recurring")("frequency_type") = "months"
	o("auto_recurring")("transaction_amount") = 77
	o("auto_recurring")("currency_id") = "BRL"
	o("auto_recurring")("start_date") = "2013-10-23T14:58:11.778-03:00"
	o("auto_recurring")("end_date") =  "2013-12-23T14:58:11.778-03:00"
		
    var_json =  o.jsString
	
	Dim mp
	Dim response
	Set mp = new Mercadopago
	
	mp.construct "client id", "client secret"	
	response= mp.create_preapproval_payment(var_json)
	
	'Decode JSON - Create Preference	
	Dim objJSON,preferenceResult 
	Set objJSON = JSON
	Set preferenceResult = objJSON.parse(join(array(response)))

		
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
