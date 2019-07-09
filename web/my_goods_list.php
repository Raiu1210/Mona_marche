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


    try
    {
        $registered_address = $_GET['registered_address'];
        $sql = "SELECT * FROM mona_marche_data 
                WHERE registered_address = '$registered_address'";

    	$res = $mysqli->query($sql);

    	$data = [];

        foreach ($res as $value) 
        {
            $temp = array();
            if($value[alive] == 1 && $value[registered_address] == $registered_address)
            {
                $temp = ['id'=>$value[id],
                         'timestamp'=>$value[timestamp],
                         'registered_address'=>$value[registered_address], 
                         'title'=>$value[title],
                         'pay_address'=>$value[pay_address],
                         'contact'=>$value[contact],
                         'memo'=>$value[memo],
                         'price'=>$value[price],
                         'currency'=>$value[currency],
                         'image_path'=>$value[image_path]
                        ];
                $data[] = $temp;
            }
        }

        $php_json = json_encode($data, JSON_UNESCAPED_UNICODE);
        echo $php_json;
    } catch(PDOException $e) {
        echo $e->getMessage();
        die();
    }
?>
