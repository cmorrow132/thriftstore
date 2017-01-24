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

    <script>
        $(document).ready(function() {
           $('#home').click(function() {
              $(location).attr('href','/front');
           });

           $('#pageSelectorUsers').click(function() {
               $('#main-content').html("");

               $.ajax({                                                                    //Send data to the back end
                   url: '/getConfig/users',
                   type: 'post',
                   dataType: 'text',
                   data: "",
                   success: function (data) {                          //AJAX request completed, deal with the results below
                       $('#main-content').html("");
                       $('#main-content').html(data);

                   }
               });
           });

           $('#chPassword').click(function() {
               $('#newPassword').val("");
               $('#newPasswordConfirm').val("");
               $('#chPasswordCancelBtn').removeAttr('hidden');
               $('#newPassword').removeAttr('hidden');
               $('#newPasswordConfirm').removeAttr('hidden');
               $('#commandType').text("chPasswordOK");
               $('#confirmUserText').val("");
               $("#chPwdWindowTitle").text("Change Password");
               $('#commandMsg').text("Enter your new password.");
               $("#chPwd-dlgHeader").removeClass("btn-danger");
               $("#chPwd-dlgHeader").addClass("btn-primary");
               $("#chPwd-dlg-btn").show();
               $('#chPwdWindow').modal({                                                //Finally open the modal
                   backdrop: 'static',
                   keyboard: false,                                                    //Disable clicking outside the modal to make it stay on screen till dismissed by return success
                   show: true
               });
           });

           $('#newPassword').keyup(function() {
               if($(this).val() != "" && $(this).val()==$('#newPasswordConfirm').val()) {
                   $('#chPasswordOKBtn').removeAttr('disabled');
               }
               else {
                   $('#chPasswordOKBtn').attr('disabled','disabled');
               }
           });

           $('#newPasswordConfirm').keyup(function() {
               if($(this).val() != "" && $(this).val()==$('#newPassword').val()) {
                   $('#chPasswordOKBtn').removeAttr('disabled');
               }
               else {
                   $('#chPasswordOKBtn').attr('disabled','disabled');
               }
           });

           $('#chPasswordOKBtn').click(function() {
               if($(this).hasClass('chPwdFinalBtn')) {
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
               }
               else {
                   $('#newPassword').attr('hidden', 'hidden');
                   $('#newPasswordConfirm').attr('hidden', 'hidden');
                   $('#chPasswordCancelBtn').hide();

                   var postData = "password=" + $('#newPassword').val();
                   $.ajax({                                                                    //Send data to the back end
                       url: '/chPwd',
                       type: 'post',
                       dataType: 'text',
                       data: postData,
                       success: function (data) {                     //AJAX request completed, deal with the results below
                           if (data == "Success") {
                               $("#chPwd-dlgHeader").removeClass("btn-primary");
                               $("#chPwd-dlgHeader").addClass("btn-success");
                               $('#commandMsg').text("Your password was reset. You will now be logged out.");
                               $('#chPasswordOKBtn').addClass('chPwdFinalBtn');
                           }
                       }
                   });
               }
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
            padding-right: 100px;
            margin-top: 50px;
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

        .label-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
            padding-bottom: 20px;
            margin-bottom: 20px;
            font-weight: normal;
            padding-left: 20px;
            padding-top: 15px;
        }

        .dynContent-label-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;

            font-weight: normal;
            padding-left: 20px;
            padding-top: 15px;
        }

        .dynContent-sublabel-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 25px;
            font-weight: normal;
        }

        .dynContent-dropdown-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            font-weight: normal;
            padding-left: 10px;
        }

        .underline {
            width: 100%;
            border-bottom: 1px solid;
            display: block;
        }

        .tplSubContentDetail {
            padding-left: 20px;
            padding-right: 20px;
            border: 2px solid;
            padding-top: 30px;
            padding-bottom: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .chPasswordLink {
            color: #337AB7;
        }
        .chPasswordLink:hover {
            color: #d9534f;
        }

        .chPwd-dlglabel-msg {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            padding-bottom: 10px;
            margin-bottom: 0px;
            padding-left: 20px;
        }

        .chPwd-dlglabel-submsg {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
            padding-bottom: 20px;
            margin-bottom: 30px;
            font-weight: normal;
            padding-left: 20px;
            padding-top: 15px;
        }

        .chPwd-dlglabel-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            font-weight: normal;
            padding-left: 20px;
            margin-bottom: 10px;

        }

        .chPwd-dlgBtn {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            font-weight: bold;
            padding-top: 10px;
            padding-left: 20px;
            padding-bottom: 10px;
            padding-right: 20px;
        }

    </style>
</head>
<body>

<div class="container">
    <div id="chPwdWindow" class="modal fade" role="dialog" data-backdrop="true" style="margin-top: 100px;">
        <div class="modal-dialog modal-md">
            <!-- Modal content-->
            <div class="modal-content">
                <div id="chPwd-dlgHeader" class="modal-header">
                    <h4 id="chPwdWindowTitle" class="modal-title text-center dlglabel-text"></h4>
                </div>
                <div class="modal-body">
                    <label class="chPwd-dlglabel-text" id="commandMsg"></label>
                    <input type="password" class="chPwd-dlglabel-text" id="newPassword" placeholder="Password "autofocus style="margin-left: 20px; padding-left: 10px; width: 90%;">
                    <input type="password" class="chPwd-dlglabel-text" id="newPasswordConfirm" placeholder="Confirm password" style="margin-left: 20px; padding-left: 10px; width: 90%;">
                    <div id="chPwd-dlg-btn" class="text-center" hidden="true">
                        <button type="button" id="chPasswordOKBtn" class="text-center btn btn-primary chPwd-dlgBtn" style="border: 1px solid; margin-right: 20px; margin-top: 20px;" disabled>OK</button>
                        <button type="button" id="chPasswordCancelBtn" class="text-center btn btn-primary chPwd-dlgBtn" style="border: 1px solid;  margin-top: 20px;" data-dismiss="modal">Cancel</button>
                        <label id="commandType" hidden></label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

    <nav class="navbar navbar-default" style="margin-bottom: 0px;">
        <div class="container-fluid">
            <div class="navbar-header" style="margin-bottom: 0px;">
                <a class="navbar-brand branding-text" href="#">Produce Management System</a>
                <a class="pull-right navbar-brand branding-subtext">Configuration</a>
                <p>
                    <label class="branding-sublabel-text">User: {{.CurrentUser}}</label>
                    <label id="chPassword" class="chPasswordLink branding-sublabel-text" style="margin-left: 15px; font-size: 15px; font-weight: bold;">Change password</label>
                </p>
            </div>
            <button id="home" class="btn fa fa-home pull-right navbar-buttons" aria-hidden="true" pull-right navbar-buttons"></button>
        </div>
    </nav>

    <div class="btn-primary">
        <div class="dropdown pull-right">
            <a class="dropdown-toggle btn btn-default menu-dropdown text-left" style="margin-right: 10px; margin-top: 5px; padding-top: 0px; padding-bottom: 0px;" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Menu <span class="caret" style="font-size: 50px;"></span></a>
            <ul class="dropdown-menu">
                <li class="dynContent-dropdown-text"><a id="pageSelectorUsers">Users</a></li>
            </ul>
        </div>
    </div>

    <div id="main-content" class="main-content">
        <label class="label-text">Select a module from the dropdown.</label>
    </div>

    <div class="copyright text-center" style="height: 20px;">
        <p>{{.CopyRight}} </p>
    </div>
</body>
</html>