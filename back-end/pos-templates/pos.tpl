<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
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

            $('#dlgNewOrderWaitDlg').modal({
                backdrop: 'static',
                keyboard: false,
                show: true
            });

            $('#newOrderBtn').click(function() {
                $('#dlgNewOrderWaitDlg').modal('hide');
            });
        });
    </script>

    <style>

        body {
            background-color: white;
        }

        a {
            text-decoration: none;
        }

        .main-content {
            padding-left: 100px;
        }

        radio {
            border-color: black;
        }

        .header-buttons {
            font-size: 220%;
            width: 90px;
            border: 0px;
            padding-top: 0px;
            padding-bottom: 0px;
            color: #ffffff;
            background-color: #428bca;
        }

        .page-controls {
            border-radius: 10px;
            height: 50px;
            margin-bottom: 20px;
            padding-bottom: 45px;
        }

        .category-control {
            font-size: 200%;
            text-align: left;
            border: 1px solid;
            background-color: #edfffe;
            width: 76%;
        }

        .menu-dropdown {
            font-size: 150%;
            text-align: left;
            border: 1px solid;
            background-color: #edfffe;
        }
        .caret-icon {
            text-align: right;
        }

        .category-data {
            font-family: Arial, Helvetica, Monospace;
            font-size: 600%;
        }

        .inputs {
            width: 76%;
            font-family: Arial, Helvetica, Monospace;
            font-size: 200%;
            height: 50px;
            margin-bottom: 20px;
            border: 1px solid;
            border-radius: 10px;
            padding-left: 20px;
        }

        .title-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 70px;
        <!-- height: 120px; --//>
        padding-bottom: 20px;
        margin-bottom: 20px;
        font-weight: normal;
        padding-left: 20px;<div id = "dialog-1"
        title = "Dialog Title goes here...">This my first jQuery UI Dialog!</div>
        <button id = "opener">Open Dialog</button>
        text-decoration: underline;
        }

        .discountlabel-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 40px;
            font-weight: normal;
            padding-left: 20px;
            width: 65px;
            border-radius: 50%;
        }

        .dlglabel-msg {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            padding-bottom: 20px;
            margin-bottom: 0px;
            padding-left: 20px;
        }

        .dlglabel-submsg {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
        <!-- height: 120px; --//>
        padding-bottom: 20px;
        margin-bottom: 30px;
        font-weight: normal;
        padding-left: 20px;
        padding-top: 15px;
        }

        .dlglabel-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;

            font-weight: normal;
            padding-left: 20px;

        }

        .sublabel-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 20px;
            font-style: italic;

            padding-bottom: 20px;
            margin-bottom: 20px;
            font-weight: normal;
            padding-left: 20px;
            padding-top: 15px;
        }

        .box-noborder {
            border-radius: 10px;
            padding-left: 50px;
            padding-right: 50px;
        }

        .hidden {
            opacity: 0;
        }
        .visible {
            display: block;
        }

        .radio-lineup {
            padding-left: 50px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 400%;
        }

        .btn-cons {
            margin-right: 30px;
            min-width: 120px;
            margin-bottom: 20px;
            width: 350px;
        }

        .btn-yellow {
            background: rgb( 253, 169, 0 );
        }

        .color-buttons {
            font-size: 50px;
            height: 50px;
            border-radius: 50px;
            width: 50px;
            border: 1px solid;
        }

        .category-buttons {
            font-size: 20px;
            background-color: white;
            text-align: left;
        }

        .category-buttons:hover {
            background-color: #3071a9;
            color: white;
        }
        .active {
        <!-- background-color:   #737373  !important; -->
            border: 10px solid black;
            border-radius: 50px;
        }

        .inactive {
            border: 10px solid black;
            border-radius: 50px;
        }

        .barcode {
            border-radius: 5px;
            height: 50px;
            margin-left: 15px;
            padding-left: 20px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 200%;
            text-align: left;
            border: 1px solid;
            background-color: silver;
            width: 55%;

        }

        .barcode-btn {
            border-radius: 10px;
            border: 1px;
            border-style: solid;
            height: 50px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 200%;
            border: solid;
            margin-bottom: 10px;
        }
        .clsNewCode {
            background-color: #A06100 !important;
        }
        .clsPrintCode {
            background-color: #1F8603 !important;
        }
        .clsScanCode {
            background-color: #A06100 !important;
        }
        .clsDisableBtn {
            background-color: #c0c0c0 !important;
            color: #a9a9a9;
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

        #colorChooser {
            top: 20%;
        }

        #categoryChooser {
            top: 10%;
        }

        #dlgNewOrderWaitDlg {
            top: 20%;
        }
        .categorySelections {
            border: none;
            background-color: white;
            padding-left: 50px;
        }

        .numberBox {
            width: auto;
            margin-left: 20px;
        }

        .number-buttons {
            border-radius: 5px;
            border: 1px;
            border-style: solid;
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
            border: 1px solid;
            margin-right: 10px;
            padding-left: 20px;
            padding-right: 20px;
            margin-bottom: 5px;
            background-color: #adc0d0;
        }

        .numberboxValue {
            border-radius: 5px;
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
            border: 1px solid;
            margin-left: 20px;
            margin-right: 10px;
            margin-bottom: 10px;
            padding-left: 20px;
        }

        .navbar-buttons {
            background-color: white;
            font-size: 200%;
        }
        .navbar-buttons:hover {
            color: #0741A0;
        }

        .pos-buttons {
            font-size: 200%;
            width: 350px;
        }

        .content {
            margin-left: 100px;
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
            margin-bottom: 0px;
            width: 50%;
            padding-top: 10px;
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

        .branding-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 30px;
            padding-top: 25px;
        }

        .box {
            border: 1px solid;
            border-radius: 5px;
            padding-bottom: 10px;
            margin-bottom: 200px;
            padding-left: 50px;
            padding-right: 50px;
            padding-top: 30px;
            overflow: scroll;
            width: 100%;
        }

        .col-1 {
            width: 70%;
        }
        .col-2 {
            width: 20%;
            padding-left: 50px;
        }

        .discountbox-col1 {
            width: 50%;
            padding-left: 20px;
        }

        .discountbox-col2 {
            width: 100%;
            padding-bottom: 20px;
        }

        .row::after {
            content: "";
            clear: both;
            display: table;
        }
        [class*="col-"] {
            float: left;
        }

        #homeButton {
            margin-left: 50px;
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

    </style>
</head>
<body>

<!--####################################################################### //-->
<div class="container">
    <div id="dlgNewOrderWaitDlg" class="modal fade" role="dialog" data-backdrop="true">
        <div class="modal-dialog modal-md">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-body" style="padding-top: 40px;">
                    <div id="dlg-btn" class="text-center">
                        <button id="newOrderBtn" type="button" class="text-center btn btn-primary label-text" style="width: 30%; border: 1px solid; font-size: 30px; font-style: bold; padding-left: 10px; padding-right: 10px; padding-top: 10px; padding-bottom: 10px;">New Order</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--####################################################################### //-->

    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand branding-text" href="#">Product Management System</a>
                <p>
                    <label class="branding-sublabel-text">User: {{.CurrentUser}}</label>
                    <label id="licenseWarning" class="branding-sublabel-text" style="color: red"></label>
                </p>
            </div>
            <button id="home" class="btn fa fa-home pull-right navbar-buttons" aria-hidden="true" pull-right navbar-buttons"></button>
            <button id="logout" class="btn fa fa-sign-out pull-right navbar-buttons" aria-hidden="true" pull-right navbar-buttons></button>
        </div>
    </nav>

    <div class="content">
        <p><label class="label-text" style="padding-bottom: 0px; margin-bottom: 0px;">Order Number: </label><label id="lblOrderNum" style="padding-bottom: 0px; margin-bottom: 0px;"></label></p>
        <div class="row"><div class="col-1">
            <div class="box" style="height: 400px; margin-bottom: 0px;">

            </div>
            <p>
                <label class="label-text" style="padding-bottom: 0px; margin-bottom: 0px;">Subtotal:</label><label id="lblSubtotal" style="padding-left: 10px; padding-bottom: 0px; margin-bottom: 0px; width: 140px;"></label>
                <label class="label-text" style="padding-bottom: 0px; margin-bottom: 0px;">Tax:</label><label id="lblTax" style="padding-left: 10px; padding-bottom: 0px; margin-bottom: 0px;  width: 140px;"></label>
                <label class="label-text" style="padding-bottom: 0px; margin-bottom: 0px;">Total:</label><label id="lblTotal" style="padding-left: 10px; padding-bottom: 0px; margin-bottom: 0px;  width: 140px;"></label>
            </p>
        </div><div class="col-2">
            <p><button class="btn btn-primary pos-buttons" disabled>Finalize</button></p>
            <p><button class="btn btn-primary pos-buttons" disabled>Lookup Item</button></p>
            <p><button class="btn btn-primary pos-buttons" disabled>Remove Item</button></p>
            <p><button class="btn btn-primary pos-buttons" disabled>Cancel</button></p>
        </div></div>
    </div>

    <div class="copyright text-center" style="height: 20px;">
        <p>{{.CopyRight}} </p>
    </div>

</body>
</html>