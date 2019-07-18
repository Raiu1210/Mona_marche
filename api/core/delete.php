<?php 
	$mysqli = new mysqli("localhost", "qkrc111094-2", "UWLtsK6w", "qkrc111094-2");
    if ($mysqli->connect_error)
    {
        echo $mysqli->connect_error;
        exit();
    } 
    else
    {
        $mysqli->set_charset("utf8");
    }


    if(isset($_GET['registered_address']) && isset($_GET['id']))
    { 
        $registered_address = $_GET['registered_address'];
        $delete_id = $_GET['id'];

        try
    	{
        	$sql = "UPDATE mona_marche_data
        			SET alive = 0 
                	WHERE (registered_address = '$registered_address'
            	  	  AND  id = '$delete_id')";

    		$res = $mysqli->query($sql);
			echo $res;

    	} catch(PDOException $e) {
        	echo $e->getMessage();
        	die();
    	}
    } 

    
?>
