<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Pagar</title>
  </head>
  <body>
     
  <h3>Cartão Teste VISA : 4235 6477 2802 5682 </h3>
  <h3>Cartão Teste MASTER : 5031 4332 1540 6351 </h3>  
  <h3>Cartão Teste AMEX : 3753 651535 56885 </h3>    
     
  <form action="response.asp" method="post" id="form-pagar-mp">
    <input id="amount" name="amount" type="hidden" value="235"/>
	<p><div id="bandeira"></div> Numero do Cartão: <input data-checkout="cardNumber" type="text" /></p>
	<p>Codigo de segurança: <input data-checkout="securityCode" type="text" value="123" /></p>
    <p>Mês vencimento: <input data-checkout="cardExpirationMonth" type="text" value="05"  /></p>
    <p>Ano de vencimento: <input data-checkout="cardExpirationYear" type="text" value="2018" /></p>
    <p>Titular do cartão: <input data-checkout="cardholderName" type="text" value="APRO" /></p>
    <p>Número do documento: <input data-checkout="docNumber" type="text" value="19119119100" /></p>
    <p>Parcelas: <select name="installmentsOption" id="installmentsOption"></select>
	<input data-checkout="paymentMethod" type="hidden" name="paymentMethod" />
    <input data-checkout="docType" type="hidden" value="CPF"/>
    <input data-checkout="siteId" type="hidden" value="MLB"/>
    <p><input type="submit" value="Concluir pagamento"></p>
	
</form>  
     
     
  <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
  <script type="text/javascript" src="https://secure.mlstatic.com/org-img/checkout/custom/1.0/checkout.js"></script>
  <script type="text/javascript">
    Checkout.setPublishableKey("public_key");
     
     $("input[data-checkout='cardNumber']").bind("keyup",function(){
      var bin = $(this).val().replace(/ /g, '').replace(/-/g, '').replace(/\./g, '');
      if (bin.length == 6){
        Checkout.getPaymentMethod(bin,setPaymentMethodInfo);
      }
    });
 
    //Estabeleça informação do meio de pagamento obtido
    function setPaymentMethodInfo(status, result){
		$.each(result, function(p, r){
		$("input[data-checkout='paymentMethod']").attr("value", r.id)
		var img = "<img src=" + r.thumbnail + " align='left' style='margin-right:10px;' >";
		$("#bandeira").empty();
		$("#bandeira").append(img);
		Checkout.getInstallments(r.id ,parseFloat($("#amount").val()), setInstallmentInfo);
		 return;
       });
    };
	
	function setInstallmentInfo(status, installments){
	  var html_options = "";
	  for(i=0; installments && i<installments.length; i++){
		  html_options += "<option value='"+installments[i].installments+"'>"+installments[i].installments +" de "+installments[i].share_amount+" ("+installments[i].total_amount+")</option>";
	  };
	  $("#installmentsOption").html(html_options);
	};
     
    $("#form-pagar-mp").submit(function( event ) {
    var $form = $(this);
    Checkout.createToken($form, mpResponseHandler);
    event.preventDefault();
    return false;
    });
 
var mpResponseHandler = function(status, response) {
  var $form = $('#form-pagar-mp');
 
  if (response.error) {
    console.log (response.error);
    alert("Ocorreu um erro");
  } else {
    var card_token_id = response.id;
    $form.append($('<input type="hidden" id="card_token_id" name="card_token_id"/>').val(card_token_id));
    $form.get(0).submit();
  }
};
     
     
  </script>
  </body>
</html>
