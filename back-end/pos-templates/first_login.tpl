<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Management System Initial Setup</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript"></script>

    <!-- <script src="http://code.jquery.com/jquery-1.4.1.min.js"></script> -->

    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel='stylesheet' type='text/css'>

    <script>
        $(document).ready(function() {
            $('#password').keyup(function () {
                $('#errorLbl').text("");

                $(this).val($(this).val().replace(/\s+/g, ''));

                //alert($('#password').val());

                if ($(this).val() != "" && $('#passwordConfirm').val() != "") {
                    $('#btnSave').removeAttr('disabled');
                }
                else {
                    $('#btnSave').attr('disabled','disabled');
                }
            });

            $('#passwordConfirm').keyup(function () {
                $('#errorLbl').text("");

                $(this).val($(this).val().replace(/\s+/g, ''));

                if ($(this).val() != "" && $('#password').val() != "") {
                    $('#btnSave').removeAttr('disabled');
                }
                else {
                    $('#btnSave').attr('disabled','disabled');
                }
            });

            $('#btnSave').click(function() {

               if($('#password').val() != $('#passwordConfirm').val()) {
                   $('#errorLbl').text("The passwords do not match.");
               }
               else {
                   $('#errorLbl').text("");
                   var password = $('#password').val();

                   var postData = "password\=" + password;
                   $.ajax({                                                                    //Send data to the back end
                       url: '/chPwd',
                       type: 'post',
                       dataType: 'text',
                       data: postData,
                       success: function (data) {                          //AJAX request completed, deal with the results below
                           if (data == "Success") {
                               $("#msgTitle").text("");
                               $('#msg').text("Your password was updated.");
                               $("#dlgHeader").addClass("btn-primary");

                               $('#msgBox').modal({                                                //Finally open the modal
                                   backdrop: 'static',
                                   keyboard: false,                                                    //Disable clicking outside the modal to make it stay on screen till dismissed by return success
                                   show: true
                               });
                               //$(location).attr('href', "/front");
                           }
                           else {
                               $('#erroLbl').text(data);             //Login unsuccessful
                               $('#password').val("");
                               $('#passwordConfirm').val("");
                           }
                       }
                   });
               }
            });

            $('#continueBtn').click(function() {
                $(location).attr('href', "/front");
            });
        });


    </script>
    <style>
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

        .content {
            margin-left: 50px;
            margin-right: 50px;
            margin-top: 50px;
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
            font-size: 30px;
            padding-bottom: 0px;
            margin-bottom: 0px;
            font-weight: normal;
            padding-left: 20px;
        }

        .errorLabel-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            padding-bottom: 0px;
            margin-bottom: 0px;
            font-weight: normal;
            padding-left: 30px;
            color: red;
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

<div class="container">
    <div id="msgBox" class="modal fade" role="dialog" style="margin-top: 100px;" data-backdrop="true">
        <div class="modal-dialog modal-md">
            <!-- Modal content-->
            <div class="modal-content">

                <div class="modal-body">
                    <div>
                        <label class="label-text text-center" id="msg"></label>
                        </div>
                    </div>
                    <div id="dlg-btn" class="text-center">
                        <button id="continueBtn" type="button" class="text-center btn btn-primary label-text" style="width: 30%; border: 1px solid; font-size: 30px; font-style: bold; padding-left: 10px; padding-right: 10px; padding-top: 10px; padding-bottom: 10px; margin-bottom: 20px; margin-top: 20px" data-dismiss="modal">Continue</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand branding-text">Product Management System</a>
            <a class="pull-right navbar-brand branding-subtext">First Login</a>
        </div>
    </div>
</nav>


<div class="content" style="position: absolute; left: 20%;">
    <p>
        <label class="label-text">This is your first time logging in. Set a password.</label>
    </p>
    <p>
        <input id="password" type="password" class="label-text" placeholder="Password" style="margin-left: 20px;">
    </p>
    <p>
        <input id="passwordConfirm" type="password" class="label-text" placeholder="Confirm password" style="margin-left: 20px;">

            <button id="btnSave" class="btn btn-primary" style="margin-left: 20px; font-size: 25px;" disabled="disabled">Save</button>
    </p>
    <p>
        <label id="errorLbl" class="errorLabel-text"></label>
    </p>
</div>

<div class="copyright text-center" style="height: 20px;">
    <p>{{.CopyRight}} </p>
</div>

</body>
</html>