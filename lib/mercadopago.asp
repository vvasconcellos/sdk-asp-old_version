<!--#include file="json2.asp"-->
<%

' MercadoPago Integration Library
' Access MercadoPago for payments integration
' 
' @author Victor Vasconcellos


Const API_BASE_URL = "https://api.mercadolibre.com"
Const MIME_JSON = "application/json"
Const MIME_FORM = "application/x-www-form-urlencoded"
Const version = "0.1.0"

Class Mercadopago

Dim Client_Id
Dim  Client_Secret

Public Property Get getClient_Id
		getClient_Id=Client_Id		
End Property

Public Function SetClient_Id(varClient_Id)
		Client_Id = varClient_Id
End Function

Public Property Get getClient_Secret
		getClient_Secret=Client_Secret
End Property

Public Function SetClient_Secret(varClient_Secret)
		Client_Secret= varClient_Secret
End Function

Function exec(Method,URL,Content_Type,Body)
	
	On error resume next
		
	Dim xmlHttp
	Dim resposta
	
    Set xmlHttp = Server.Createobject("MSXML2.ServerXMLHTTP")
    
	xmlHttp.Open Method,API_BASE_URL & URL, False
    xmlHttp.SetRequestHeader "Accept", MIME_JSON
    xmlHttp.SetRequestHeader "Content-Type", Content_Type
    xmlHttp.setRequestHeader "User-Agent", "MercadoPago ASP SDK v" & version
    xmlHttp.Send Body
	
	If Err.number <> 0 then  Call  Error_Message()
	
	if xmlHttp.Status = 200 OR xmlHttp.Status = 201 then
	  
	  exec = xmlHttp.responsetext
	
	else
	
	  response.write " <br> STATUS: " & xmlHttp.Status & " ERROR => " &  xmlHttp.responsetext & " <br> "
	
	end if 
	
    xmlHttp.abort()
    Set xmlHttp = Nothing  
	
	Exit Function

	If Err.number <> 0 then  Call  Error_Message()
		

	
End Function

'*
'* Create a checkout preference
'* @return String retJSON.access_token
'*

Function get_access_token() 

	On error resume next
	
	Dim resp_json,method,url,body
		
	method = "POST"
	url = "/oauth/token"
	body = "grant_type=client_credentials&client_id=" & getClient_Id & "&client_secret=" & getClient_Secret
		
	resp_json = exec(method,url,MIME_FORM,body)
		
	Dim objJSON,retJSON 

	Set objJSON = JSON
	Set retJSON = objJSON.parse(join(array(resp_json)))
		
	If Err.number <> 0 then  Call  Error_Message()
		
	get_access_token = retJSON.access_token

End Function

'*
'* Create a checkout preference
'* @param String(Json-Format) preference
'* @return String(Json-Format) result_pref
'*
 Function create_preference(preference) 
 
	On error resume next
        
	Dim accessToken,method,url, result_pref
	accessToken = get_access_token		
			
	method = "POST"
	url = "/checkout/preferences?access_token=" & accessToken

	result_pref = exec(method,url,MIME_JSON,preference)

	If Err.number <> 0 then  Call  Error_Message()
	
	create_preference = result_pref
	
End Function

'*
'* Get information for specific payment
'* @param int id
'* @return String(Json-Format) payment_info
'*

Function get_payment_info(id)
	
	On error resume next
	
	Dim accessToken,method,url,payment_info

	accessToken = get_access_token

	method = "GET"
	url = "/collections/notifications/" & id & "?access_token=" & accessToken
	
	payment_info = exec(method,url,MIME_JSON,null)

	If Err.number <> 0 then  Call  Error_Message()
	
	get_payment_info = payment_info

End Function

'*
'* Refund accredited payment
'* @param int id
'* @return String(Json-Format) refund
'*

Function refund_payment(id)
	
	On error resume next
	
	Dim accessToken,method,url,body
	Dim refund

	accessToken = get_access_token

	method = "PUT"
	url = "/collections/" & id & "?access_token=" & accessToken
	body = "{""status"":""refunded""}"
	
	refund = exec(method,url,MIME_JSON,body)

	If Err.number <> 0 then  Call  Error_Message()
	
	refund_payment = refund

End Function


'*
'* Cancel pending payment
'* @param int id
'* @return String(Json-Format) cancel
'*

Function cancel_payment(id)
	
	On error resume next
	
	Dim accessToken,method,url,body
	Dim cancel

	accessToken = get_access_token

	method = "PUT"
	url = "/collections/" & id & "?access_token=" & accessToken
	body = "{""status"":""cancelled""}"
	
	cancel = exec(method,url,MIME_JSON,body)

	If Err.number <> 0 then  Call  Error_Message()
	
	cancel_payment = cancel

End Function


'**
'* Cancel preapproval payment
'* @param int id
'* @return String(Json-Format) cancel
'*
  
Function cancel_preapproval_payment(id)

Dim accessToken,method,url,body
Dim cancel

	accessToken = get_access_token

	method = "PUT"
	url = "/preapproval/" & id & "?access_token=" & accessToken
	body = "{""status"":""cancelled""}"
	
	cancel = exec(method,url,MIME_JSON,body)

	If Err.number <> 0 then  Call  Error_Message()
	
	cancel_payment = cancel


End Function


'*
'* Search payments according to filters, with pagination
'* @param String filters
'* @param int offset
'* @param int limit
'* @return String(Json-Format) search_pay
'*

Function search_payment(filters,offset,limit)
	
	On error resume next
	
	Dim accessToken,method,url,search_pay

	accessToken = get_access_token
	
	If Isnull(offset) then offset=0
	If Isnull(limit) then limit=0
	
	filters = filters & "&offset=" & offset & "&limit=" & limit

	method = "GET"
	url = "/collections/search?" & filters & "&access_token=" & accessToken
	
	search_pay = exec(method,url,MIME_JSON,null)

	If Err.number <> 0 then  Call  Error_Message()
	
	search_payment = search_pay

End Function

'*
'* Update a checkout preference
'* @param String id
'* @param String(Json-Format) preference
'* @return String(Json-Format) update_pref
'*
 Function update_preference(id,preference) 
 
	On error resume next
        
	Dim accessToken,method,url, update_pref
	accessToken = get_access_token		
			
	method = "PUT"
	url = "/checkout/preferences/" & id & "?access_token=" & accessToken
	
	update_pref = exec(method,url,MIME_JSON,preference)
	
	If Err.number <> 0 then  Call  Error_Message()
		
	update_preference = update_pref
	
End Function

'*
'* Get a checkout preference
'* @param String id
'* @return String(Json-Format) get_pref
'*

Function get_preference(id)
	
	On error resume next
	
	Dim accessToken,method,url,get_pref

	accessToken = get_access_token

	method = "GET"
	url = "/checkout/preferences/" & id & "?access_token=" & accessToken
	
	get_pref = exec(method,url,MIME_JSON,null)

	If Err.number <> 0 then  Call  Error_Message()
	
	get_preference = get_pref

End Function

'**
'* Create a preapproval payment
'* @param  String(Json-Format) preapproval_payment
'* @return String(Json-Format) result_pref
'*

Function create_preapproval_payment(preappr_payment) 
 
	On error resume next

	Dim accessToken,method,url, result_pref
	
	accessToken = get_access_token		
			
	method = "POST"
	url = "/preapproval?access_token=" & accessToken

	result_pref = exec(method,url,MIME_JSON,preappr_payment)
			
	If Err.number <> 0 then  Call  Error_Message()
	
	create_preapproval_payment = result_pref
	
End Function

'**
'* Get a preapproval payment
'* @param string id
'* @return String(Json-Format) get_pref
'*

Function get_preapproval_payment(id)
	
	On error resume next
	
	Dim accessToken,method,url,get_pref

	accessToken = get_access_token

	method = "GET"
	url = "/preapproval/" & id & "?access_token=" & accessToken
	
	get_pref = exec(method,url,MIME_JSON,null)

	If Err.number <> 0 then  Call  Error_Message()
	
	get_preapproval_payment = get_pref

End Function


Function construct(ClientID,ClientSecret)
	
	SetClient_Id(ClientID)
	SetClient_Secret(ClientSecret)

End Function

Function Error_Message()

Response.Write " <br> *** Error *** : (" & Err.number & " - " & err.Description & ") <br> " 

End Function

End Class





%>
