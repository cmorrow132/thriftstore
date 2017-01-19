<html>
<head>
	<title>{{.ActionTitle}}</title>

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
	<!-- <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script> -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript"></script>

	<!-- <script src="http://code.jquery.com/jquery-1.4.1.min.js"></script> -->

    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel='stylesheet' type='text/css'>

	<script>
		$(document).ready(function() {

		            var pageType="{{.PageType}}";
		            switch(pageType) {
		                case "newItem":
		                    $('#bCodeBtn').addClass('clsDisableBtn');
		                    $('#bCodeBtn').attr('disabled','disabled');
		                    break;
		                    //$('#bCodeBtn').blur();
                        case "exItem":
                            $('#selected_category').attr('disabled','disabled');
                            $('#price').attr('disabled','disabled');
                            $('#itemDescription').attr('disabled','disabled');
                            $('#selectedColorCode').attr('disabled','disabled');
                            $('#ExItemApply').attr('disabled','disabled');
                            $('#ExItemApply').addClass('clsDisableBtn');
                            break;
		            }

                    $("#bCodeBtn").click(function () {
                        $(this).blur();                                         //Remove focus to prevent highlighting button, visual thing
                        if($(this).hasClass('clsNewCode')) {                    //Template is for new items, generate a new bar code

                            var postData="category_id="+$('#selected_category').val();

                            $.ajax({                                            //Send GET request to back end
                                url: '/mkBarCode',
                                type: 'post',
                                dataType: 'text',
                                data : postData,
                                success : function(data) {                  //AJAX request completed, deal with the results below
                                    if(data.substr(0,5)=="Error") {                         //There was some error creating the bar code
                                        $("#warningTitle").text("Error");                   //Open the error msg modal
                                        $('#warningMsg').text(data);
                                        $("#dlgHeader").addClass("btn-danger");
                                        $("#dlgHeader").removeClass("btn-success");
                                        $("#dlgProgressSpinner").hide();
                                        $("#dlg-btn").show();
                                        $('#warningBox').modal({
                                            backdrop: 'static',
                                            keyboard: false,
                                            show: true
                                        });
                                    }
                                    else {
                                        $('#bCodeID').val(data);                        //Bar code returned, set bar code in box
                                        $('#bCodeBtn').text(' Print');                  //Change button to reflect print instead of New
                                        $('#bCodeBtn').removeClass('clsNewCode');       //Change class for new barcode button
                                        $('#bCodeBtn').addClass('clsPrintCode');        //Code generated, change to print button
                                        $('#bCodeBtn').removeAttr("selected");          //Unhighlight button since it was clicked
                                    }
                                }
                            });
                        }
                        else if($(this).hasClass('clsScanCode')) {              //Existing item template, set button for scan codes
                            alert("Scanning bar code");                         //..fill in code here to handle scanning codes and once scanned and returned,
                                                                                //change to print button, see above for CSS class changes
                        }
                        else if($(this).hasClass('clsPrintCode')) {             //Print barcode button


                            $("#warningTitle").text("Printing");                   //Open the error msg modal
                            $('#warningMsg').text("Printing bar code");
                            $("#dlgHeader").removeClass("btn-danger");
                            $("#dlgHeader").addClass("btn-success");
                            $("#dlgProgressSpinner").show();
                            $("#dlg-btn").hide();
                            $('#warningBox').modal({
                                backdrop: 'static',
                                keyboard: false,
                                show: true
                            });

                            var postData="";
                            $.ajax({                                                                    //Send data to the back end
                                url: '/printCode',
                                type: 'post',
                                dataType: 'text',
                                data: postData,
                                success: function (data) {                          //AJAX request completed, deal with the results below
                                    if (data == "Success") {
                                        $('#warningBox').modal('hide');

                                        $('#bCodeBtn').removeClass('clsPrintCode');
                                        $('#bCodeBtn').addClass('clsDisableBtn');
                                        $('#bCodeBtn').attr('disabled','disabled');
                                        $('#bCodeBtn').blur();

                                        $('#btnReload').addClass('clsDisableBtn');
                                        $('#btnReload').attr('disabled','disabled');
                                        $('#pageSelector').attr('disabled','disabled');
                                        $('#selected_category').attr('disabled','disabled');
                                        $('#itemDescription').attr('disabled','disabled');
                                        $('#price').attr('disabled','disabled');
                                        $('#selectedColorCode').attr('disabled','disabled');


                                    }
                                }
                            });
                        }
                    });

                    $("#btnReload").click(function () {                         //Reload the page
                        location.reload();
                    });

                    $("[name=color]").click(function() {                                                    //Color chooser opened and color selected
                        var itemClicked=$(this).val();                                                      //Get selected color
                        $("#selectedColorCode").val(itemClicked);                                           //Set value on #SelectedColorCode
                        $("#selectedColorCode").css('background-color',$(this).css('background-color'));    //Change background color of selected color code label/button on main page

                        $("#colorOptions").removeClass('visible');                                          //Remove color chooser modal visibility
                        $("#colorOptions").addClass('hidden');                                              //Add color chooser modal hidden
                    });

                    $("[name=categoryName]").click(function () {                //Item selected from category modal
                        var itemClicked=$(this).val();                          //store selected item value in variable
                        $("#selected_category").val(itemClicked);               //Set value on label for selected category
                        $("#selected_category").text($(this).text());              //Set text on label for selected category

                        if(getPriceValue()>0) {                                 //if a category was selected and price is greater than 0
                            $('#bCodeBtn').removeClass('clsDisableBtn');        //enable the barcode button
                            $('#bCodeBtn').removeAttr('disabled');
                            $('#ExItemApply').removeClass('clsDisableBtn');                        //enable the apply button for existing item pages
                            $('#ExItemApply').removeAttr('disabled');
                        }
                    });

                    //################# PRICE DIALOG ###############
                    $('#price').click(function () {                                                     //Price box clicked
                        $(this).blur();
                        $('#priceInputLabel').text("");                                  //Set the price value in the price modal based on
                                                                                                        //the price label in the main page
                        $('#numberBox').modal({                                                         //Open the price modal
                            backdrop: 'static',
                            keyboard: true,
                            show: true
                        });

                    });

                    $('#btnPriceSubmit').click(function () {                            //Submit button pressed on the price modal
                        var price=$("#priceInputLabel").text();                                                //Get the price value
                        var priceCents="";                                                          //Set cents to null in case none was entered
                        var priceDollar="";
                        var pricePlaceholder=price.split(".");                                      //Split dollars and cents

                        if(pricePlaceholder[0]) {
                            priceDollar=pricePlaceholder[0];
                        }
                        else {
                            priceDollar="0";
                        }
                        //var priceDollar=pricePlaceholder[0].substr(0,pricePlaceholder[0].length)    //Store dollars in priceDollar
                        if(pricePlaceholder[1]) {                                                   //Store cents in priceCents if it was entered
                            priceCents=pricePlaceholder[1];
                            if(priceCents.length==1) { priceCents=priceCents+"0"; }
                        }
                        else {
                            priceCents="00";                                                        //Set priceCents to "00" if none was entered
                        }
                        var priceModifier=priceDollar+"."+priceCents                                //Set float version of price for DB data type

                        $('#price').val("$"+priceModifier);                  //Set the price label on the main page with the new value
                        $('#numberBox').modal('hide');                                  //and hide the modal

                        if(getPriceValue()>0 && $('#selected_category').val() != "") {
                            $('#bCodeBtn').removeClass('clsDisableBtn');                        //enable the barcode button for new item pages
                            $('#bCodeBtn').removeAttr('disabled');
                            $('#ExItemApply').removeClass('clsDisableBtn');                        //enable the apply button for existing item pages
                            $('#ExItemApply').removeAttr('disabled');
                        }

                    });

                    function getPriceValue() {
                        var price=$("#price").val();                                                //Get the price value
                        var priceCents="";                                                          //Set sents to null in case none was entered
                        var pricePlaceholder=price.split(".");                                      //Split dollars and cents
                        var priceDollar=pricePlaceholder[0].substr(1,pricePlaceholder[0].length)    //Store dollars in priceDollar
                        if(pricePlaceholder[1]) {                                                   //Store cents in priceCents if it was entered
                            priceCents=pricePlaceholder[1];
                        }
                        else {
                            priceCents="00";                                                        //Set priceCents to "00" if none was entered
                        }
                        var priceModifier=priceDollar+"."+priceCents                                //Set float version of price for DB data type

                        return priceModifier;
                    }

                    $("[name=priceNumBtn]").click(function() {
                        var numVal=$(this).val();
                        var exValue=$('#priceInputLabel').text();

                        $('#priceInputLabel').text(exValue+numVal);

                    });

                    $('#btnPriceBkspc').click( function () {
                        priceValue=$("#priceInputLabel").text();

                        if(priceValue.length>0) {
                            $("#priceInputLabel").text(priceValue.substr(0,priceValue.length-1));
                        }
                    });
                    /############ HOME PAGE BUTTON CLICKED #######################//
                    $('#homeButton').click(function () {

                        bCodeBtnColor=$('#bCodeBtn').css('background-color');
                        submitBtnColor=$('#NewItemApply').css('background-color');

                        //Bar code printed, but item not submitted yet
                        if($('#bCodeBtn').hasClass("clsPrintCode") && bCodeBtnColor=="rgb(192, 192, 192)") {
                             $("#warningTitle").text("Error");                                       //Set modal title to Error
                             $('#warningMsg').text("A bar code has been printed, this item must be added to the system.");                   //Set modal msg to error
                             $("#dlgHeader").removeClass("btn-success");                             //Remove green title bar
                             $("#dlgHeader").addClass("btn-danger");                                 //Set red title bar
                             $("#dlgProgressSpinner").hide();                                        //Hide the spinner since we don't want it on errors
                             $("#dlg-btn").show();                                                   //Finally open the modal
                             $('#warningBox').modal({
                                 backdrop: 'static',
                                 keyboard: false,
                                 show: true
                             });
                        }

                        else if($('#bCodeBtn').hasClass('clsDisableBtn') && $('#bCodeBtn').text()==" Print")
                        {
                            $("#warningTitle").text("Error");                                       //Set modal title to Error
                            $('#warningMsg').text("A bar code has been printed. You must submit this item to inventory.");                   //Set modal msg to error
                            $("#dlgHeader").removeClass("btn-success");                             //Remove green title bar
                            $("#dlgHeader").addClass("btn-danger");                                 //Set red title bar
                            $("#dlgProgressSpinner").hide();                                        //Hide the spinner since we don't want it on errors
                            $("#dlg-btn").show();                                                   //Finally open the modal
                            $('#warningBox').modal({
                                backdrop: 'static',
                                keyboard: false,
                                show: true
                            });
                        }
                        //Values changed, bar code not printed, but item has not been added
                        else if(getPriceValue()>0 || $('#selected_category').val() != "")
                        {
                            $("#warningTitle").text("Error");                                       //Set modal title to Error
                            $('#warningMsg').text("You will lose any unsaved data.");                   //Set modal msg to error
                            $("#dlgHeader").removeClass("btn-success");                             //Remove green title bar
                            $("#dlgHeader").addClass("btn-danger");                                 //Set red title bar
                            $("#dlgProgressSpinner").hide();                                        //Hide the spinner since we don't want it on errors
                            $("#dlg-btn").show();                                                   //Finally open the modal
                            $('#warningBox').modal({
                                backdrop: 'static',
                                keyboard: false,
                                show: true
                            });
                        }

                        else {
                            $(location).attr('href', '{{.MobOrPcHomeBtn}}');
                             //}
                        }

                    });
                    //

                    //########### HANDLE ADDING NEW ITEMS TO THE DATABASE ##################
                    $('#NewItemApply').click(function () {                                              //New item apply button
                                                                                                        //Check that all fields are completed
                        var price=$("#price").val();
                        var priceTotal=parseFloat(price.substr(1,price.length));

                        if(!priceTotal) { priceTotal=0; }

                        var bCodeBtnColor=$('#bCodeBtn').css('background-color');
                        if($("#bCodeBtn").hasClass('clsPrintCode') && bCodeBtnColor=="rgb(31, 134, 3)") {
                            $("#warningTitle").text("Error");                                       //Set modal title to Error
                            $('#warningMsg').text("You must print the bar code before adding the product.");                   //Set modal msg to error
                            $("#dlgHeader").removeClass("btn-success");                             //Remove green title bar
                            $("#dlgHeader").addClass("btn-danger");                                 //Set red title bar
                            $("#dlgProgressSpinner").hide();                                        //Hide the spinner since we don't want it on errors
                            $("#dlg-btn").show();                                                   //Finally open the modal
                            $('#warningBox').modal({
                                backdrop: 'static',
                                keyboard: false,
                                show: true
                            });
                        }

                        else if($('#bCodeID').val()=="" || $('#selected_category').val()==""  || priceTotal==0)      //Some fields incomplete
                        {
                            $("#warningTitle").text("Error");                                       //Set modal title to Error
                            $('#warningMsg').text("Some fields are incomplete.");                   //Set modal msg to error
                            $("#dlgHeader").removeClass("btn-success");                             //Remove green title bar
                            $("#dlgHeader").addClass("btn-danger");                                 //Set red title bar
                            $("#dlgProgressSpinner").hide();                                        //Hide the spinner since we don't want it on errors
                            $("#dlg-btn").show();                                                   //Finally open the modal
                            $('#warningBox').modal({
                                backdrop: 'static',
                                keyboard: false,
                                show: true
                            });
                        }
                        else {
                            $("#warningTitle").text("Adding Product");                              //Data was entered appropriately
                            $('#warningMsg').text("Sending product to inventory database.");        //Set msg adding products
                            $("#dlgHeader").removeClass("btn-danger");                              //Remove red title bar
                            $("#dlgHeader").addClass("btn-success");                                //Add green title bar
                            $("#dlgProgressSpinner").show();                                        //Show the spinner for status
                            $("#dlg-btn").hide();                                                   //Hide the OK button, we want this to remain on scree till back end returns a success
                            $('#warningBox').modal({                                                //Finally open the modal
                                backdrop: 'static',
                                keyboard: false,                                                    //Disable clicking outside the modal to make it stay on screen till dismissed by return success
                                show: true
                            });

                            var price=getPriceValue();
                                                                                                      //create POST request data
                            var postData="bcode\="+ $('#bCodeID').val()+"&category\="+$("#selected_category").val()+"&price\="+price+"&description\="+$('#itemDescription').val()+"&colorcode\="+$('#selectedColorCode').val();

                            $.ajax({                                                                    //Send data to the back end
                                url: '/addProduct',
                                type: 'post',
                                dataType: 'text',
                                data : postData,
                                success : function(data) {                          //AJAX request completed, deal with the results below
                                    if(data=="Success") {
                                        $('#warningBox').modal('hide');                                 //Hide the modal if back end returned success on adding
                                        $('#NewItemApply').removeClass('');
                                        $('#NewItemApply').addClass('clsDisableBtn');                     //Disable the add item button to prevent re-adding
                                        $('#NewItemApply').attr('disabled','disabled');
                                        $('#btnReload').addClass('clsDisableBtn');               //Item has been submitted
                                        $('#btnReload').attr('disabled','disabled');            //Do not allow reloading to clear data at this point

                                        $('#selected_category').attr('disabled','disabled');
                                        $('#selected_category').addClass('clsDisableBtn');
                                        $('#price').attr('disabled','disabled');
                                        $('#price').addClass('clsDisableBtn');
                                        $('#itemDescription').attr('disabled','disabled');
                                        $('#itemDescription').addClass('clsDisableBtn');
                                        $('#selectedColorCode').attr('disabled','disabled');
                                        //$('#selectedColorCode').addClass('clsDisableBtn');

                                        $(location).attr('href', '{{.MobOrPcHomeBtn}}/new-item')                           //Item added, reload blank new item page
                                    }
                                    else {                                                              //Change status to error if back end returned error on adding item
                                        $("#warningTitle").text("Error");
                                        $('#warningMsg').text(data);
                                        $("#dlgHeader").addClass("btn-danger");
                                        $("#dlgHeader").removeClass("btn-success");
                                        $("#dlgProgressSpinner").hide();
                                        $("#dlg-btn").show();
                                    }
                                }
                            });
                        }
                    });
                    //########### END HANDLE ADDING NEW ITEMS TO THE DATABASE ##################


                    $('#ExItemApply').click(function () {                       //Existing item, apply any changes
                        alert("Updating existing item");
                    });

                    $.fn.setCursorPosition = function(pos) {                    //This function is supposed to handle what happens
                      this.each(function(index, elem) {                         //when the price box is clicked, for setting the
                        if (elem.setSelectionRange) {                           //cursor, but needs work
                          elem.setSelectionRange(pos, pos);
                        } else if (elem.createTextRange) {
                          var range = elem.createTextRange();
                          range.collapse(true);
                          range.moveEnd('character', pos);
                          range.moveStart('character', pos);
                          range.select();
                        }
                      });
                      return this;
                    };

            $('#logout').click(function() {
                $.ajax({                                            //Send GET request to back end
                    url: '/logout',
                    type: 'post',
                    dataType: 'text',
                    data: "",
                    success: function (data) {                  //AJAX request completed, deal with the results below
                        var pageURL=window.location.href.split("/");

                        if (data == "Logout") {                         //Logout completed on server side


                            $(location).attr('href', "/"+pageURL[3]);
                        }
                    }
                });
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
			<!-- height: 120px; --//>
			padding-bottom: 20px;
			margin-bottom: 20px;
			font-weight: normal;
			padding-left: 20px;
			padding-top: 15px;
		}

		.box {
			border: 1px solid;
			border-radius: 5px;
			padding-bottom: 10px;
			margin-bottom: 200px;
            width: 500px;
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

        #warningBox {
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

        .col-1 {
            width: 50%;
        }
        .col-2 {
            width: 50%;
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

	</style>
</head>

<body>

<!-- ################## DIALOG BOXES ################## -->
<div class="container">
    <div id="colorChooser" class="modal fade" role="dialog" data-backdrop="true">
        <div class="modal-dialog modal-md">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header btn-primary">
                    <h4 class="modal-title text-center" style="font-size: 20px;">Choose a category for this item</h4>
                </div>
                <div class="modal-body">
                    <div class="categorybox-noborder" style="padding-left: 20px;">
                        <ul>
                            {{GetColors}}
                        </ul>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>

<div class="container">
<div id="categoryChooser" class="modal fade" role="dialog" data-backdrop="true">
  <div class="modal-dialog modal-md">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header btn-primary">
            <h4 class="modal-title text-center" style="font-size: 20px;">Choose a category for this item</h4>
      </div>
      <div class="modal-body">
            <div class="categorybox-noborder">
                <ul>
                    {{FnMbiTrkc}}
                </ul>
            </div>
      </div>

    </div>

  </div>
</div>
</div>

<div class="container">
    <div id="warningBox" class="modal fade" role="dialog" data-backdrop="true">
        <div class="modal-dialog modal-md">
        <!-- Modal content-->
            <div class="modal-content">
                <div id="dlgHeader" class="modal-header">
                    <h4 id="warningTitle" class="modal-title text-center dlglabel-text"></h4>
                </div>
                <div class="modal-body">
                    <div>
                        <label class="dlglabel-msg text-center" id="warningMsg"></label>
                        <label class="dlglabel-submsg" style="font-style: italic; font-weight: bold;" id="warningSubMsg"></label>
                            <div class="text-center label-text" style="padding-bottom: 10px;" id="dlgProgressSpinner">
                                <i class="fa fa-circle-o-notch fa-spin" style="font-size: 200%;"></i>
                            </div>
                    </div>
                    <div id="dlg-btn" class="text-center" hidden="true">
                        <button type="button" class="text-center btn btn-primary label-text" style="width: 30%; border: 1px solid; font-size: 30px; font-style: bold; padding-left: 10px; padding-right: 10px; padding-top: 10px; padding-bottom: 10px;" data-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<div id="numberBox" class="modal fade" role="dialog" data-backdrop="true">
    <div class="modal-dialog modal-sm" style="width: 25%;">
        <div class="modal-content" style="width: 100%;">
            <div class="modal-header btn-primary" style="padding-top: 10px;">
                <h4 class="modal-title label-text text-center dlglabel-text" style="margin-bottom: 0px; padding-botton: 10px;">Price Input</h4>
            </div>
            <div class="modal-body" style="width: 100%;">
                <label id="priceInputLabel" class="numberboxValue" style="width: 60%;"></label>
                <button id="btnPriceSubmit" class="fa fa-arrow-right btn-success" style="font-size: 30px; background-color: #5cb85c; padding-top: 5px; padding-bottom: 5px;"></button>
                <div class="numberBox">
                <p>
                    <button name="priceNumBtn" value="7" class="btn number-buttons">7</button>
                    <button name="priceNumBtn" value="8" class="btn number-buttons">8</button>
                    <button name="priceNumBtn" value="9" class="btn number-buttons">9</button>
                </p>
                <p>
                    <button name="priceNumBtn" value="4" class="btn number-buttons">4</button>
                    <button name="priceNumBtn" value="5" class="btn number-buttons">5</button>
                    <button name="priceNumBtn" value="6" class="btn number-buttons">6</button>
                </p>
                <p>
                    <button name="priceNumBtn" value="1" class="btn number-buttons">1</button>
                    <button name="priceNumBtn" value="2" class="btn number-buttons">2</button>
                    <button name="priceNumBtn" value="3" class="btn number-buttons">3</button>
                </p>
                <p>
                    <button name="priceNumBtn" value="0" class="btn number-buttons">0</button>
                    <button name="priceNumBtn" value="." class="btn number-buttons">.</button>
                    <button id="btnPriceBkspc" class="btn fa fa-arrow-left" style="font-size: 30px; background-color: #f0ad4e; color: white;"></button>
                </p>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- ################## END DIALOG BOXES ################## -->


<nav class="navbar navbar-default" style="margin-bottom: 0px;">
    <div class="container-fluid">
        <div class="navbar-header" style="margin-bottom: 0px;">
            <a class="navbar-brand branding-text" href="#">Produce Management System - {{.ActionTitle}}</a>
        </div>
        <button id="logout" class="btn fa fa-sign-out pull-right navbar-buttons" aria-hidden="true" pull-right navbar-buttons"></button>
    </div>
</nav>


    <nav class="navbar navbar-default">
        <div class="container-fluid btn-primary">
            <div class="navbar-header">
                <row class="cox-xs-12">
                    <button id="homeButton" class="btn btn-default fa fa-home header-buttons"></button>
                    <button id="{{.ApplyBtnName}}" class="btn btn-default fa fa-check header-buttons"></button>
                    <button id="btnReload" class="btn btn-default fa fa-refresh header-buttons"></button>
                </row>

        </div>
            <div class="dropdown pull-right">
                <a href="#" id="pageSelector" class="dropdown-toggle btn btn-default menu-dropdown text-left" style="margin-right: 10px; margin-top: 5px; padding-top: 0px; padding-bottom: 0px;" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">{{.ActionTitle}} <span class="caret" style="font-size: 50px;"></span></a>
                <ul class="dropdown-menu">
                    <li><a href="/front/new-item">Add Item</a></li>
                    <li><a href="/front/get-item">Item Lookup</a></li>
                </ul>
            </div>
    </nav>

<div class="container-fluid main-content" style="margin-top: 0px; padding-top: 0px;">

<div class="row"><div class="col-1">
    <p>
        <div class="input-prepend">
                <input id="bCodeID" class="barcode" type="text" placeholder="Product BarCode" value="{{.BarCodeID}}" disabled>
        <button id="bCodeBtn" class="btn btn-info barcode-btn {{.ClsbCodeBtn}}" aria-hidden="true" style="border: 1px solid black;"><i class="fa fa-barcode "> {{.BarcodeBtnLabel}}</i></button>
        </div>
    </p>

    <row>
        <div class="col-md-12">
            <div class="dropdown">
                <button id="selected_category" value="" class="dropdown-toggle btn btn-default page-controls category-control text-left" type="button" data-toggle="modal" data-target="#categoryChooser">Category
                    <i class="fa fa-caret-down" aria-hidden="true"></i>
                </button>


            </div>
        </div>
    </row>

    <row>
        <div class="col-md-12">
            <input id="price" class="inputs" type=text placeholder="$" value="{{.ItemPrice}}">
            <!-- <button id="price" value="" class="dropdown-toggle btn btn-default page-controls category-control text-left" type="button" data-toggle="dropdown">Price</button>
            <div class="dropdown-menu" style="margin-top: 0px; margin-left: 20px; padding: 15px; padding-bottom: 0px;">

                    <p>
                        <button name="priceNumBtn" value="7" class="btn number-buttons">7</button>
                        <button name="priceNumBtn" value="8" class="btn number-buttons">8</button>
                        <button name="priceNumBtn" value="9" class="btn number-buttons">9</button>
                        <button id="btnPriceSubmit" class="number-buttons fa fa-arrow-right btn-success" style="background-color: #5cb85c; padding-top: 25px; padding-bottom: 30px; border: 2px solid;"></button>
                    </p>
                    <p>
                        <button name="priceNumBtn" value="4" class="btn number-buttons">4</button>
                        <button name="priceNumBtn" value="5" class="btn number-buttons">5</button>
                        <button name="priceNumBtn" value="6" class="btn number-buttons">6</button>
                    </p>
                    <p>
                        <button name="priceNumBtn" value="1" class="btn number-buttons">1</button>
                        <button name="priceNumBtn" value="2" class="btn number-buttons">2</button>
                        <button name="priceNumBtn" value="3" class="btn number-buttons">3</button>
                    </p>
                    <p>
                        <button name="priceNumBtn" value="0" class="btn number-buttons">0</button>
                        <button name="priceNumBtn" value="." class="btn number-buttons">.</button>
                        <button id="btnPriceBkspc" class="btn number-buttons fa fa-arrow-left" style="background-color: #f0ad4e; color: white;"></button>
                    </p>

            </div> -->
        </div>
    </row>

    <row>
        <div class="col-md-12">
            <input id="itemDescription" class="form-control inputs" type="text" placeholder="Item Description (Optional)">
        </div>
    </row>

</div><div class="col-2">           <!-- Column 2 -->
        <div class="box">
            <center>
                <label id="colorLabel" class="text-center label-text" style="margin-bottom: 0px;">Color Codes</label>
            </center>
            <p>
                <label class="text-center label-text" style="padding-top: 0px; margin-top: 0px; margin-bottom: 0px; padding-bottom: 0px;">Selected Color Code: </label>
            </p><p>
            <center>
                <button class="label-text" id="selectedColorCode" data-toggle="modal" data-target="#colorChooser" value="{{.SelectedColorCode}}" style="border: 1px solid; font-size: 40%; background-color: {{.SelectedColorCodeHtml}}; margin-top: 0px; width: 100px; margin-left: 20px; border-radius: 50px;">&nbsp&nbsp&nbsp;</button>
            </center>
            </p>

            <div class="row">
                <div class="discountbox-col1">
                    <p>
                        <label class="sublabel-text">Current discounts: </label>
                    </p>
                </div><div class="discountbox-col2 text-center">
                    {{FncGlobalDiscount1}}
                </div>
            </div>


        </div>
    </div>          <!-- end column 2 -->
</div>              <!-- end row -->

</div>
<div class="copyright text-center" style="height: 20px;">
	<p>{{.CopyRight}} </p>
</div>

</body>
</html>
