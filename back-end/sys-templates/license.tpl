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
            var licenseStatus = '{{.LicenseStatus}}';
            if (licenseStatus == "1054") {
                $('#licenseStatus').text("Could not communicate with the license server.");
            }
            else if(licenseStatus=="expired") {
                $('#licenseStatus').text("Your license is expired.");
            }
            else if(licenseStatus=="invalid") {
                $('#licenseStatus').text("Invalid license.");
            }
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
<div class="container-fluid main-content">
    <p>
        <row>
            <label class="label-text" id="licenseStatus"></label>
        </row>
    </p>

</div>

<div class="copyright text-center" style="height: 20px;">
    <p>{{.CopyRight}} </p>
</div>

</body>
</html>