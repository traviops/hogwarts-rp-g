<?php
	if(!isset($_GET['autenticado'])) {
		if(!isset($_POST['de']) || !isset($_POST['para']) || !isset($_POST['tit']) || !isset($_POST['msg']))
			die ("ERRO - MAIL DESAUTENTICADO");
		$charset = $_POST['charset'];
		$de = $_POST['de'];
		$nomerem = $_POST['nomerem'];
		$para = $_POST['para'];
		if($charset == "utf-8") {			
			$titulo = utf8_encode($_POST['tit']);
			$msg = utf8_encode($_POST['msg']);
		} else {
			$titulo = $_POST['tit'];
			$msg = $_POST['msg'];
		}
		$type = $_POST['type'];
		$headers = "MIME-Version: 1.1\r\n";
		$headers .= "Content-type: $type; charset=$charset\r\n";
		//$headers .= "From: $de\r\n"; // remetente
    	$headers .= (isset($_POST['nomerem'])) ? ("From: ".$nomerem." <".$de.">\r\n") : ("From: $de\r\n");
		$headers .= "Return-Path: $de\r\n"; // return-path	
		$envio = mail($para, $titulo, $msg, $headers);
		if(!$envio) echo 'E-mail nใo enviado.';
		else echo 'E-mail enviado';
	}
	else {
		if(!isset($_POST['de']) || !isset($_POST['senha']) || !isset($_POST['host']) || !isset($_POST['porta']) || !isset($_POST['para']) || !isset($_POST['tit']) || !isset($_POST['msg']))
			die ("ERRO - MAIL AUTENTICADO");
		include ("phpmailer/PHPMailerAutoload.php"); 
		$mail = new PHPMailer();
		$mail->IsSMTP();
		$mail->SetLanguage("br");
		$mail->CharSet = $_POST['charset'];
		$mail->Username = $mail->From = $_POST['de'];
		$mail->FromName = (isset($_POST['nomerem'])) ? ($_POST['nomerem']) : ($_POST['de']);
		$mail->Password = $_POST['senha'];	
		$mail->Host = $_POST['host'];
		$mail->Port = $_POST['porta'];
		$mail->SMTPAuth = true;
		$mail->SMTPSecure = 'tls';
		$msg = $_POST['msg'];
		if($_POST['charset'] == "utf-8") {
			$mail->Subject = utf8_encode($_POST['tit']);
			$mail->Body = utf8_encode($msg);
			$mail->AltBody = utf8_encode($msg);
		} else {
			$mail->Subject = $_POST['tit'];
			$mail->Body = $msg;
			$mail->AltBody = $msg;		
		}
		
		$mail->IsHTML((($_POST['type'] == "text/html") ? (true) : (false)));
		$mail->AddAddress($_POST['para']);
		$envio = $mail->Send();	
		if(!$envio) {
			echo '[ERRO] ERRO DE AUTENTICAวรO. ALTERANDO PARA MODO SEM AUTENTICAวรO';
			$para = $_POST['para'];
			$type = $_POST['type'];
			$de = $_POST['de'];
			$charset = $_POST['charset'];
			if($charset == "utf-8") {
				$msg = utf8_encode($_POST['msg']);
				$titulo = utf8_encode($_POST['tit']);
			}
			else {
				$titulo = $_POST['tit'];
			}
			$headers = "MIME-Version: 1.1\r\n";
			$headers .= "Content-type: $type; charset=$charset\r\n";
			$headers .= "From: $de\r\n"; // remetente
			$headers .= "Return-Path: $de\r\n"; // return-path	
			$envio = mail($para, $titulo, $msg, $headers);
			if(!$envio) echo 'E-mail nใo enviado.';
			else echo 'E-mail enviado';
		}
		else echo '[AUTENTICADO] E-mail enviado';
	}

?>