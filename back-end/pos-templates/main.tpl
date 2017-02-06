<html>
<head>

    <title>{{.ActionTitle}}</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
    <!-- <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script> -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript"></script>

    <!-- <script src="http://code.jquery.com/jquery-1.4.1.min.js"></script> -->

    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel='stylesheet' type='text/css'>

    <script>
        $(document).ready(function() {

            var licenseDaysLeft={{.LicenseDaysLeft}};
            if(licenseDaysLeft < 30) {
                $('#licenseWarning').text("License expires in " + licenseDaysLeft + " days");
            }

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

            $('#config').click(function() {
                $(location).attr('href','/front/config');
            });
        });

    </script>

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

        a {
            text-decoration: none;
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
            margin-top: 50px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 200%;
        }

        .button-container {
            margin-left: 100px;
            margin-right: 100px;
        }

        .content-buttons {
            margin-bottom: 20px;
            width: 50%;
            padding-top: 10px;
        }

        .label-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 40px;
             padding-bottom: 20px;
            margin-bottom: 20px;
            font-weight: normal;
            padding-left: 20px;
            padding-top: 15px;
        }

        .branding-sublabel-text {
            font-family: Arial, Helvetica, Monospace;
            color: #575757;
            font-size: 20px;
            font-weight: normal;
            margin-left: 20px;
            padding-top: 0px;
            margin-bottom: 0px;
            padding-bottom: 0px;
        }

        .branding-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
            padding-top: 25px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand branding-text" href="#">Product Management System</a>
                <p>
                    <label class="branding-sublabel-text">User: {{.CurrentUser}}</label>
                    <label id="licenseWarning" class="branding-sublabel-text" style="color: red"></label>
                </p>
            </div>
             <button id="config" class="btn glyphicon glyphicon-cog pull-right navbar-buttons"></button>
            <button id="logout" class="btn fa fa-sign-out pull-right navbar-buttons" aria-hidden="true" pull-right navbar-buttons"></button>
        </div>
    </nav>

    <div class="content">
        <div class="button-container">
            <center>
                <button onclick="location.href = '/front/pos';" class="btn btn-primary btn-block label-text content-buttons" style="border-radius: 50px;">Point Of Sale</button></a>
                <button onclick="location.href = '/front/new-item';"class="btn btn-primary btn-block label-text content-buttons" style="border-radius: 50px;">Inventory Management</button>
            </center>
        </div>
    </div>

    <div class="copyright text-center" style="height: 20px;">
        <p>{{.CopyRight}} </p>
    </div>

</body>
</html>