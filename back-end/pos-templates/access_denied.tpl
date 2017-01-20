<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript"></script>

    <!-- <script src="http://code.jquery.com/jquery-1.4.1.min.js"></script> -->

    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel='stylesheet' type='text/css'>

    <script>
        $(document).ready(function() {
            $('#logout').click(function() {
                $.ajax({                                            //Send GET request to back end
                    url: '/logout',
                    type: 'post',
                    dataType: 'text',
                    data: "",
                    success: function (data) {                  //AJAX request completed, deal with the results below
                        var pageURL=window.location.href.split("/");

                        if (data == "Logout") {                         //Logout completed on the server side
                            $(location).attr('href', "/"+pageURL[3]);
                        }
                    }
                });
            });

            $('#return').click(function () {
                var pageURL=window.location.href.split("/");
                $(location).attr('href', "/"+pageURL[3]);
            });
        });

    </script>

    <style>
        .branding-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
            padding-top: 25px;
        }

        .navbar-buttons {
            background-color: white;
            font-size: 250%;
        }
        .navbar-buttons:hover {
            color: #0741A0;
        }

        .content {
            margin-left: 50px;
            margin-right: 50px;
            margin-top: 35px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 200%;
        }

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

        .label-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            padding-bottom: 0px;
            margin-bottom: 0px;
            font-weight: normal;
            padding-left: 20px;
        }

        a {
            color: #0741A0;
        }
        a:hover {
            color: deepskyblue;
        }

    </style>

</head>
<body>

    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand branding-text" href="#">Product Management System</a>
            </div>
            <button id="logout" class="btn fa fa-sign-out pull-right navbar-buttons" aria-hidden="true" pull-right navbar-buttons"></button>
        </div>
    </nav>

    <div class="content">
        <p>
            <label class="label-text">You do not have permission to access this module. See your administrator for assistance.</label>
            <br>
            <a href="#" id="return"><label class="label-text">Return.</label></a>
        </p>
    </div>

    <div class="copyright text-center" style="height: 20px;">
        <p>{{.CopyRight}} </p>
    </div>

</body>
</html>