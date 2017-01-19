<!DOCTYPE html>
<html lang="en">
<head>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
    <!-- <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script> -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript"></script>

    <!-- <script src="http://code.jquery.com/jquery-1.4.1.min.js"></script> -->

    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel='stylesheet' type='text/css'>

    <meta charset="UTF-8">
    <title>Product Management System - Config</title>

    <style>
        .copyright {
            position:fixed;
            bottom:0;
            width:100%;
            display:block;
            font-family: Arial, Helvetica, Monospace;
            font-size: 15px;
            background-color: #000345;
            color: white;
        }

        .branding-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
            padding-top: 25px;
        }

        .branding-subtext {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            padding-top: 30px;
        }

        .navbar-buttons {
            background-color: white;
            font-size: 250%;
        }
        .navbar-buttons:hover {
            color: #0741A0;
        }

        .menu-dropdown {
            font-size: 150%;
            width: 150px;
            text-align: left;
            border: 1px solid;
            background-color: #edfffe;
        }

        a {
            text-decoration: none;
        }

        .main-content {
            padding-left: 100px;
        }

    </style>
</head>
<body>

    <nav class="navbar navbar-default" style="margin-bottom: 0px;">
        <div class="container-fluid">
            <div class="navbar-header" style="margin-bottom: 0px;">
                <a class="navbar-brand branding-text" href="#">Produce Management System</a>
                <a class="pull-right navbar-brand branding-subtext">Configuration</a>
            </div>
            <button id="logout" class="btn fa fa-home pull-right navbar-buttons" aria-hidden="true" pull-right navbar-buttons"></button>
        </div>
    </nav>

    <div class="btn-primary">
        <div class="dropdown pull-right">
            <a href="#" id="pageSelector" class="dropdown-toggle btn btn-default menu-dropdown text-left" style="margin-right: 10px; margin-top: 5px; padding-top: 0px; padding-bottom: 0px;" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Menu <span class="caret" style="font-size: 50px;"></span></a>
            <ul class="dropdown-menu">
                <li><a href="/front/new-item">Users</a></li>
                <li><a href="/front/get-item"></a></li>
            </ul>
        </div>
    </div>


    <div class="copyright text-center" style="height: 20px;">
        <p>{{.CopyRight}} </p>
    </div>
</body>
</html>