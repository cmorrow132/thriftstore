<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login page</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <!--<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" type="text/css">-->
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="/bower_components/bootstrap-horizon/bootstrap-horizon.css">
    <link rel="stylesheet" href="css/mobile.css">

    <script>
        $(document).ready(function() {
            $('#password').val("");

            $('#username').keyup(function () {
                $(this).val($(this).val().replace(/\s+/g, ''));
                $('#password').val($('#password').val().replace(/\s+/g, ''));

                //alert($('#password').val());

                if ($(this).val() != "" && $('#password').val() != "") {
                    $('#loginBtn').removeAttr('disabled');
                }
                else {
                    $('#loginBtn').attr('disabled','disabled');
                }
            });

            $('#password').keyup(function () {
                $(this).val($(this).val().replace(/\s+/g, ''));
                $('#username').val($('#username').val().replace(/\s+/g, ''));

                if ($(this).val() != "" && $('#username').val() != "") {
                    $('#loginBtn').removeAttr('disabled');
                }
                else {
                    $('#loginBtn').attr('disabled','disabled');
                }
            });

            $('#loginBtn').click(function() {
                if($('#loginBtn').is(':disabled')==false) {
                    $('#errLbl').text("");
                    var username = $('#username').val();
                    var password = $('#password').val();

                    var postData = "username\=" + username + "&password\=" + password;
                    $.ajax({                                                                    //Send data to the back end
                        url: '/login',
                        type: 'post',
                        dataType: 'text',
                        data: postData,
                        success: function (data) {                          //AJAX request completed, deal with the results below
                            if (data == "Success") {
                                if(password=="none") {
                                    //Redirect to first time login
                                    $(location).attr('href', "/front/firstLogin");
                                }
                                else {
                                    $(location).attr('href', "/front");
                                }
                            }
                            else {
                                $('#errLbl').text(data);             //Login unsuccessful
                                $('#password').val("");
                            }
                        }
                    });
                }
            });

            $(document).keyup(function (e) {
               if($(".input:focus") && (e.keyCode==13)) {
                   $('#loginBtn').click();
               }
            });

        });
    </script>

    <style>
        .container {
            width: 90%;
            margin-top:80px;
        }

        .inner-box {
            margin-left: 100px;
            margin-right: 100px;
        }

        .login-header {
            padding-top: 10px;
            padding-bottom: 10px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 150%;
            background-color: #337ab7;
            color: white;
        }

        .input-box {
            font-family: Arial, Helvetica, Monospace;
            font-size: 150%;
            padding-left: 50px;
            margin-bottom: 15px;
            border: 2px solid;
            width: 50%;
        }

        .loginBtn {
            font-family: Arial, Helvetica, Monospace;
            font-size: 200%;
            width: 50%;
        }

        .clsDisableBtn {
            background-color: #c0c0c0 !important;
            color: #a9a9a9;
            font-family: Arial, Helvetica, Monospace;
            font-size: 200%;
        }

        .errLbl {
            font-family: Arial, Helvetica, Monospace;
            font-size: 150%;
            color: red;
            margin-bottom: 10px;
            margin-top: 10px;
        }

        .hidden {
            opacity: 0;
        }

        #loginBtn {
            font-family: Arial, Helvetica, Monospace;
            font-size: 200%;
        }

        .branding-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
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

    </style>

</head>
<body>

<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand branding-text" href="#">Product Management System</a>
        </div>
    </div>
</nav>

<div class="container text-center">

    <div class="inner-box">
        <row class="login-header text-center">
            <label style="width: 50%; margin-bottom: 20px;">Login</label>
        </row>

        <center>
        <row>
            <input id="username" class="input-box btn-block text-left" placeholder="Username"></input>
        </row>
        <row>
            <input id="password" type="password" class="input-box btn-block text-left" placeholder="Password" autocomplete="new-password"></input>
        </row>
        <row>
        </center>
            <label id="errLbl" class="errLbl">&nbsp;</label>
        </row>
        <p>
            <button id="loginBtn" class="btn btn-success" disabled="disabled">Login</button>
        </p>
    </div>
</div>

<div class="copyright text-center" style="height: 20px;">
    <p>{{.CopyRight}} </p>
</div>
</body>
</html>