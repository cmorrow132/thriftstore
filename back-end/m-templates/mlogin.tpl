<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mobile login page</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <!--<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" type="text/css">-->
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="/bower_components/bootstrap-horizon/bootstrap-horizon.css">
    <link rel="stylesheet" href="css/mobile.css">

    <script>
        $(document).ready(function() {
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
                $('#errLbl').text("");
               var username=$('#username').val();
               var password=$('#password').val();

               var postData="username\=" + username + "&password\=" + password;
                $.ajax({                                                                    //Send data to the back end
                    url: '/login',
                    type: 'post',
                    dataType: 'text',
                    data: postData,
                    success: function (data) {                          //AJAX request completed, deal with the results below
                        if (data == "Success") {
                            alert("login successful");
                            location.href("/m");
                        }
                        else {
                            $('#errLbl').text(data);             //Login unsuccessful
                            $('#password').val("");
                        }
                    }
                });
            });
        });
    </script>

    <style>
        .container {
            width: 90%;
            margin-top:80px;
        }

        .inner-box {
            margin-top: 60px;
            margin-left: 30px;
            margin-right: 20px;
        }

        .login-header {
            padding-top: 20px;
            padding-bottom: 30px;
            margin-bottom: 50px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 800%;
            background-color: #337ab7;
            color: white;
        }

        .input-box {
            font-family: Arial, Helvetica, Monospace;
            font-size: 700%;
            padding-left: 50px;
            margin-bottom: 50px;
            border: 2px solid;
        }

        .loginBtn {
            font-family: Arial, Helvetica, Monospace;
            font-size: 700%;
            width: 70%;
        }

        .clsDisableBtn {
            background-color: #c0c0c0 !important;
            color: #a9a9a9;
            font-family: Arial, Helvetica, Monospace;
            font-size: 700%;
        }

        .errLbl {
            font-family: Arial, Helvetica, Monospace;
            font-size: 400%;
            color: red;
            margin-bottom: 20px;
        }

        .hidden {
            opacity: 0;
        }

        #loginBtn {
            font-family: Arial, Helvetica, Monospace;
            font-size: 700%;
        }
    </style>

</head>
<body>

<div class="container text-center">

    <row class="login-header text-center">
        <label style="width: 100%;">Login</label>
    </row>

    <div class="inner-box">
        <row>
            <input id="username" class="input-box btn-block text-left" placeholder="Username"></input>
        </row>
        <row>
            <input id="password" type="password" class="input-box btn-block text-left" placeholder="Password"></input>
        </row>
        <row>
            <label id="errLbl" class="errLbl">&nbsp;</label>
        </row>
        <p>
            <button id="loginBtn" class="btn btn-success" disabled="disabled">Login</button>
        </p>
    </div>
</div>
</body>
</html>