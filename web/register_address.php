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

    $mona_address = $mysqli->real_escape_string($_GET['mona_address']);
    echo $mona_address;
    
    $sql = "INSERT INTO registration_mona_address (
                mona_address
            )  VALUES (
                '$mona_address'
            )";

    $res = $mysqli->query($sql);
    var_dump($res);
    $mysqli->close();

?>