<!--#include file="lib/mercadopago.asp"-->
<!--#include file="lib/json2.asp"-->
<html>
    <head>
        <title>MercadoPago SDK - Search payments </title>
    </head>
    <body>
<%

' * MercadoPago SDK
' * Search payments
' * @date 2012/04/10
' * @author Victor Vasconcellos

' Create an instance with your MercadoPago credentials (CLIENT_ID and CLIENT_SECRET): 
' Argentina: https://www.mercadopago.com/mla/herramientas/aplicaciones 
' Brasil: https://www.mercadopago.com/mlb/ferramentas/aplicacoes
' Mexico: https://www.mercadopago.com/mlm/herramientas/aplicaciones 
' Venezuela: https://www.mercadopago.com/mlv/herramientas/aplicaciones 

	
	Dim payment_info
	Dim strSearch,site_id,external_reference
	
	Dim mp
	Set mp = new Mercadopago
	
	mp.construct "CLIENT_ID", "CLIENT_SECRET"
	
	' Sets the filters you want
	site_id = "MLB"
	external_reference = "Reference_1234"
	
	strSearch = "site_id="& site_id & "&external_reference=" & external_reference 
			
    ' Search payment data according to filters
	payment_info = mp.search_payment(strSearch,null,null)
	
	Response.write( "<br>" & payment_info & "<br><br>")
		
	'Dim objJSON,retJSON 
	
	'Set objJSON = JSON
	'Set retJSON = objJSON.parse(join(array(payment_info)))
	
	'Response.write( " **** DECODE JSON **** <BR><BR> ")
	'Response.write( " - id :" & retJSON.collection.id  & "<br>"  )
	'Response.write( " - external_reference :" & retJSON.collection.external_reference  & "<br>" )
	'Response.write( " - status : " & retJSON.collection.status  & "<br>"  )
	'Response.write( " - payment_type : " & retJSON.collection.payment_type  & "<br>"  )




%>
</body>
</html>