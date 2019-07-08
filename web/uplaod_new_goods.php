<?php 
	$mysqli = new mysqli();
    if ($mysqli->connect_error)
    {
        echo $mysqli->connect_error;
        exit();
    } 
    else
    {
        $mysqli->set_charset("utf8");
    }

	$target_dir = "./img/";
	$file_name  = date('Ymd_His')."_".$_REQUEST["registered_address"].".jpg";
	$image_path = $target_dir.$file_name;

	$registered_address = $_POST["registered_address"];
	$title = $_POST["title"];
	$pay_address = $_POST["pay_address"];
	$contact = $_POST["contact"];
	$memo = $_POST["memo"];
	$amount_mona = $_POST["amount_mona"];
	$global_image_path = "http://zihankimap.work/mona/img/".$file_name;

	if (move_uploaded_file($_FILES["file"]["tmp_name"], $image_path)) 
	{
		echo json_encode([
			"Message" => "The file ".basename($_FILES["file"]["name"])." has been uploaded",
			"Status" => "OK",
			"registered_address" => $registered_address,
			"title" => $title,
			"pay_address" => $pay_address,
			"contact" => $contact,
			"memo" => $memo,
			"amount_mona" => $amount_mona
		]);
	} else 
	{
		echo json_encode([
			"Message" => "There was an error while uploading",
			"Status" => "Error",
			"userId" => $_REQUEST["userId"]
		]);

		// if (isset($_POST)) {
		// 	echo "data is in $_POST";	
		// }
	}

	$sql = "INSERT INTO mona_marche_data (
                registered_address,
                title,
                pay_address,
                contact,
                memo,
                amount_mona,
                image_path,
                alive
            )  VALUES (
                '$registered_address',
                '$title',
                '$pay_address',
                '$contact',
                '$memo',
                '$amount_mona',
                '$global_image_path',
                1
            )";

    $res = $mysqli->query($sql);
 //    var_dump($res);
    $mysqli->close();
?>