<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>License page</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript"></script>

    <!-- <script src="http://code.jquery.com/jquery-1.4.1.min.js"></script> -->

    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel='stylesheet' type='text/css'>

    <script>
        $(document).ready(function() {
            var licenseStatus = "{{.LicenseStatus}}";
            if (licenseStatus == "1054") {
                $('#licenseStatus').html("Could not communicate with the license server. <label id='retryServer' class='label-text' style='color: #337ab7;'> Retry</label>");
            }
            else if(licenseStatus=="expired") {
                $('#licenseStatus').text("Your license is expired.");
                $('#curLicense').removeAttr('hidden');
            }
            else if(licenseStatus=="invalid") {
                $('#licenseStatus').text("Your license is invalid.");
                $('#enterLicense').removeAttr('hidden');
                $('#curLicense').removeAttr('hidden');
            }
            else {
                $('#licenseStatus').text(licenseStatus);
            }

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
                var postData = "license=" + $('#licenseInput').val();
                $.ajax({                                                                    //Send data to the back end
                    url: '/updateLicense',
                    type: 'post',
                    dataType: 'text',
                    data: postData,
                    success: function (data) {
                        licenseData = data.split(",")
                        switch (licenseData[0]) {
                            case "1054":
                                $('#licenseResponseStatus').text("The license serer is down.");
                                break;
                            case "invalid":
                                $('#licenseResponseStatus').text("The license is invalid.");
                                $('#saveLicenseBtn').attr('disabled', 'disabled');
                                break;
                            case "expired":
                                $('#licenseResponseStatus').text("The license is expired.");
                                $('#saveLicenseBtn').attr('disabled', 'disabled');
                                break;
                            case "valid":
                                $(location).attr('href', '/front/');
                        }
                    }
                });
            });

            $(document).on('click',"#retryServer", function() {
                $.ajax({                                                                    //Send data to the back end
                    url: '/licenseServerRetry',
                    type: 'post',
                    dataType: 'text',
                    data: "",
                    success: function (data) {
                        if (data == 1050) {
                            $(location).attr("href", "/front");
                        }
                    }
                });
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
            padding-top: 20px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 25px;
            font-weight: normal;
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

    <nav class="navbar navbar-default" style="margin-bottom: 0px;">
        <div class="container-fluid">
            <div class="navbar-header" style="margin-bottom: 0px; padding-bottom: 10px;">
                <a class="navbar-brand branding-text" href="#">Product Management System</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid main-content">

        <label class="label-text" id="licenseStatus"></label>
        <p><label class="label-text" id="curLicense" hidden>Current license: {{.ProdLicense}}</label></p>

        <div id="enterLicense" class="content" style="margin-top: 0px;" hidden>

            <p>
                <label class="label-text">New license key: </label>
                <input id="licenseInput" class="label-text" style="margin-left: 10px; margin-top: 0px; padding-top: 0px; padding-left: 10px;" autofocus>
                <button id="saveLicenseBtn" class="btn btn-primary" style="font-size: 20px; margin-left: 10px;" disabled>Save</button>
            </p>
            <p>
                <label id="licenseResponseStatus" style="font-size: 20px; color: red; font-size: 25px; margin-top: 30px; padding-top: 0px; margin-left: 60px;"></label>
            </p>
        </div>

    </div>

<div class="copyright text-center" style="height: 20px;">
    <p>{{.CopyRight}} </p>
</div>

</body>
</html>