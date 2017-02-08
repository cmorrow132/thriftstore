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
            $('#licenseInput').keyup(function() {
                $('#licenseResponseStatus').text("");

                if( $(this).val()!="") {
                    $('#saveLicenseBtn').removeAttr('disabled');
                }
                else {
                    $('#saveLicenseBtn').attr('disabled','disabled');
                }
            });

            $('#saveLicenseBtn').click(function() {
                var postData="license="+$('#licenseInput').val();
                $.ajax({                                                                    //Send data to the back end
                    url: '/updateLicense',
                    type: 'post',
                    dataType: 'text',
                    data: postData,
                    success: function (data) {
                        licenseData=data.split(",")
                        switch(licenseData[0]) {
                            case "1054":
                                $('#licenseResponseStatus').text("The license serer is down.");
                                break;
                            case "invalid":
                                $('#licenseResponseStatus').text("The license is invalid.");
                                $('#saveLicenseBtn').attr('disabled','disabled');
                                break;
                            case "expired":
                                $('#licenseResponseStatus').text("The license is expired.");
                                $('#saveLicenseBtn').attr('disabled','disabled');
                                break;
                            case "valid":
                                $(location).attr('href','/front');
                        }
                    }
                });
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

<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand branding-text">Product Management System</a>
            <a class="pull-right navbar-brand branding-subtext">Initial Setup</a>
        </div>
    </div>
</nav>


<div class="content" style="position: absolute; left: 20%;">
    <p>
        <label class="label-text">Setup step3.</label>
    </p>

</div>

<div class="copyright text-center" style="height: 20px;">
    <p>{{.CopyRight}} </p>
</div>

</body>
</html>