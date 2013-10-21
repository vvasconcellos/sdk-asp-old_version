<!--#include file="lib/mercadopago.asp"-->
<!--#include file="lib/json2.asp"-->
<html>
    <head>
        <title>MercadoPago SDK - Instant Paymnent Notification </title>
    </head>
    <body>
<%

' * MercadoPago SDK
' * Receive IPN
' * @date 2012/04/09
' * @author Victor Vasconcellos

' Create an instance with your MercadoPago credentials (CLIENT_ID and CLIENT_SECRET): 
' Argentina: https://www.mercadopago.com/mla/herramientas/aplicaciones 
' Brasil: https://www.mercadopago.com/mlb/ferramentas/aplicacoes
' Mexico: https://www.mercadopago.com/mlm/herramientas/aplicaciones 
' Venezuela: https://www.mercadopago.com/mlv/herramientas/aplicaciones 
	
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
</body>
</html>