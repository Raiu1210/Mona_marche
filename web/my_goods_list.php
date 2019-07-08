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
<<<<<<< HEAD
            if($value[alive] == 1 && $value[registered_address] == $registered_address)
=======
            if($value[alive] == 1)
>>>>>>> 5de7ed54f3143bee48dec1cc5e1cc8bdc940ba55
            {
                $temp = ['id'=>$value[id],
                		 'timestamp'=>$value[timestamp],
                         'registered_address'=>$value[registered_address], 
                         'title'=>$value[title],
<<<<<<< HEAD
                         'pay_address'=>$value[pay_address],
                         'contact'=>$value[contact],
=======
                         'pay_address'=>$value[pay_address], 
>>>>>>> 5de7ed54f3143bee48dec1cc5e1cc8bdc940ba55
                         'memo'=>$value[memo],
                         'amount_mona'=>$value[amount_mona],
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
