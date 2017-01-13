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
		                    //$('#bCodeBtn').blur();
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
                            alert("Printing bar code");

                            $(this).removeClass('clsPrintCode');
                            $(this).addClass('clsDisableBtn');
                            $(this).attr('disabled','disabled');
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
                        }
                    });

                    $('#price').click(function () {                                                     //Price box clicked
                        //$('#price').val("$"+getPriceValue());
                        $('#numberBox').modal({
                            backdrop: 'static',
                            //keyboard: false,
                            show: true
                        });

                    });

                    $('#price').on("change paste keyup", function() {                           //if price goes above $0 and a category is selected
                        var pageType="{{.PageType}}"

                        if(getPriceValue()>0 && $('#selected_category').val() != "") {
                            $('#bCodeBtn').removeClass('clsDisableBtn');                        //enable the barcode button for new item pages
                            $('#bCodeBtn').removeAttr('disabled');
                            $('#ExItemApply').removeClass('clsDisableBtn');                        //enable the apply button for existing item pages
                            $('#ExItemApply').removeAttr('disabled');
                        }
                        else {                                                                  //if price goes back to 0,
                            if(getPriceValue()==0) {
                                switch(pageType) {
                                    case "newItem":
                                        $('#bCodeBtn').addClass('clsDisableBtn');                       //disable the barcode button for new items
                                        $('#bCodeBtn').attr('disabled','disabled');
                                    case "exItem":
                                        $('#ExItemApply').addClass('clsDisableBtn');                    //disable the apply button for existing items
                                        $('#ExItemApply').attr('disabled','disabled');
                                }
                            }
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

                    /############ HOME PAGE BUTTON CLICKED #######################//
                    $('#homeButton').click(function () {
                        //Check to see if the print button is enabled, if so info has been generated but bar code not printed yet

                        var bCodeBtnColor=$('#bCodeBtn').css('background-color');
                        if($('#bCodeBtn').hasClass('clsPrintCode') && bCodeBtnColor=="rgb(31, 134, 3)") {
                                        var msgText="A bar code has not been printed for this item.";
                                        var msgSubText="Use the reload button to clear changes first.";
                                        $("#warningTitle").text("Warning");                   //Open the error msg modal
                                        $('#warningMsg').text(msgText);
                                        $('#warningSubMsg').text(msgSubText);
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

                        //Bar code was printed but data has not been saved to the database
                        else {
                            var colorCode=$('#NewItemApply').css('background-color');
                            if(colorCode=="rgb(5, 180, 0)") {
                                if($("#selected_category").val() != "" || getPriceValue() !=0 || $('#itemDescription').val()!="") {
                                    alert("You will lose any unsubmitted data");
                                }
                            }
                        }
                    });

                    //
                    //########### HANDLE ADDING NEW ITEMS TO THE DATABASE ##################
                    $('#NewItemApply').click(function () {                                              //New item apply button
                                                                                                        //Check that all fields are completed
                        var price=$("#price").val();
                        var priceTotal=parseFloat(price.substr(1,price.length));

                        if(!priceTotal) { priceTotal=0; }

                        if($('#bCodeID').val()=="" || $('#selected_category').val()==""  || priceTotal==0)      //Some fields incomplete
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
			padding-left: 10px;
			padding-right: 10px;
			margin-right: 10px;
		}

		radio {
			border-color: black;
		}

		.header-buttons {
			font-size: 600%;
			margin-bottom: 15px;
			
		}

		.page-controls {
			border-radius: 10px;
			height: 120px;
			margin-bottom: 30px;
			padding-bottom: 50px;
		}

		.category-control {
			font-size: 500%;
			text-align: left;
			border: solid;
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
			font-family: Arial, Helvetica, Monospace;
			font-size: 70px;
			height: 120px;
			margin-bottom: 30px;
			border: solid;
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

		.label-text {
			font-family: Arial, Helvetica, Monospace;
			font-size: 70px;
			<!-- height: 120px; --//>
			padding-bottom: 20px;
			margin-bottom: 20px;
			font-weight: normal;
			padding-left: 20px;
			padding-top: 15px;
		}

        .dlglabel-msg {
			font-family: Arial, Helvetica, Monospace;
			font-size: 60px;
			<!-- height: 120px; --//>
			padding-bottom: 60px;
			margin-bottom: 0px;
			font-weight: normal;
			padding-left: 20px;
			padding-top: 15px;
        }

        .dlglabel-submsg {
			font-family: Arial, Helvetica, Monospace;
			font-size: 40px;
			<!-- height: 120px; --//>
			padding-bottom: 60px;
			margin-bottom: 30px;
			font-weight: normal;
			padding-left: 20px;
			padding-top: 15px;
        }

		.dlglabel-text {
			font-family: Arial, Helvetica, Monospace;
			font-size: 70px;
			<!-- height: 120px; --//>
			padding-bottom: 10px;
			font-weight: normal;
			padding-left: 20px;
			padding-top: 10px;
		}

		.sublabel-text {
			font-family: Arial, Helvetica, Monospace;
			font-size: 50px;
			font-style: italic;
			<!-- height: 120px; --//>
			padding-bottom: 20px;
			margin-bottom: 20px;
			font-weight: normal;
			padding-left: 20px;
			padding-top: 15px;
		}

		.box {
			border: solid;
			border-radius: 10px;
			padding-bottom: 10px;
			margin-bottom: 200px;
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
			font-size: 70px;
		}

        .category-buttons {
            font-size: 70px;
            background-color: white;
            text-align: left;
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
			border-radius: 10px;
			height: 120px;
			margin-bottom: 50px;
			margin-left: 15px;
			<!-- padding-bottom: 50px; //-->
			font-family: Arial, Helvetica, Monospace;
			font-size: 500%;
			text-align: left;
			border: solid;
			background-color: silver;
			width: 65%;

		}

		.barcode-btn {
			border-radius: 10px;
			border: 1px;
			border-style: solid;
			height: 120px;
			margin-bottom: 50px;
			margin-top: 10px;
			<!-- padding-bottom: 50px; //-->
			font-family: Arial, Helvetica, Monospace;
			font-size: 500%;
			border: solid;
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
			font-size: 40px;
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

		.numberBtn {
		    border-radius: 10px;
		    border: 1px solid;
		    padding-left: 10px;
		    padding-right: 10px;
		    padding-top: 10px;
		    padding-bottom: 10px;
		    background-color: white;
		    font-size: 70px;
		    font-family: Arial, Helvetica, Monospace;
		    font-style: bold;
		}

	</style>
</head>

<body>

<!-- ################## DIALOG BOXES ################## -->
<div class="container">
<div id="colorChooser" class="modal fade" role="dialog" data-backdrop="true">
  <div class="modal-dialog modal-lg" style="width: 90%;">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header btn-primary">
            <h4 class="modal-title text-center" style="font-size: 50px;">Choose a color code for this item</h4>
      </div>
      <div class="modal-body">
            <div id="colorOptions" class="box-noborder">
                <div class="btn-group color-buttons" data-toggle="buttons">
                    <div id="colorButtonGroup">
                    {{GetColors}}
                    </div>
                </div>
            </div>
      </div>

    </div>

  </div>
</div>
</div>

<div class="container">
<div id="categoryChooser" class="modal fade" role="dialog" data-backdrop="true">
  <div class="modal-dialog modal-lg" style="width: 90%;">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header btn-primary">
            <h4 class="modal-title text-center" style="font-size: 50px;">Choose a category for this item</h4>
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
        <div class="modal-dialog modal-lg" style="width: 90%;">
        <!-- Modal content-->
            <div class="modal-content">
                <div id="dlgHeader" class="modal-header">
                    <h4 id="warningTitle" class="modal-title text-center dlglabel-text"></h4>
                </div>
                <div class="modal-body">
                    <div>
                        <label class="dlglabel-msg text-center" id="warningMsg"></label>
                        <label class="dlglabel-submsg" style="font-style: italic; font-weight: bold;" id="warningSubMsg"></label>
                            <div class="text-center label-text" style="padding-bottom: 50px;" id="dlgProgressSpinner">
                                <i class="fa fa-circle-o-notch fa-spin" style="font-size: 300%;"></i>
                            </div>
                    </div>
                    <div id="dlg-btn" class="text-center" hidden="true">
                        <button type="button" class="text-center btn btn-primary label-text" style="width: 50%; border: 1px solid;" data-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="container">
    <div id="numberBox" class="modal fade" role="dialog" data-backdrop="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div id="dlgHeader" class="modal-header btn-primary">
                    <h2 id="" class="modal-title text-center dlglabel-text">Price</h2>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- ################## END DIALOG BOXES ################## -->

<row class="col-md-12">
	<button class="btn btn-block btn-success text-center label-text" style="background-color: #00274D;">{{.ActionTitle}}</button>
</row>

<div class="container-fluid main-content">

<row>
	<div class="col-xs-4">
		<button id="homeButton" class="btn btn-block btn-primary fa fa-home page-controls header-buttons"></button>
	</div>
	<div class="col-xs-4">
		<button id="{{.ApplyBtnName}}" class="btn btn-success btn-block fa fa-check header-buttons page-controls" style="background-color: #05B400;"></button>
	</div>
	<div class="col-xs-4">
		<button id="btnReload" class="btn btn-yellow btn-block fa fa-refresh header-buttons page-controls"></button>
	</div>	
</row>

<row>
	<div class="input-prepend">
			<input id="bCodeID" class="barcode" type="text" placeholder="Product BarCode" value="{{.BarCodeID}}" disabled>
			<button id="bCodeBtn" class="btn btn-info barcode-btn fa fa-barcode {{.ClsbCodeBtn}}" aria-hidden="true" style="border: 1px solid black;"> {{.BarcodeBtnLabel}}</button>
	</div>
</row>

<row>
	<div class="col-md-12">
		<div class="dropdown">
			<button id="selected_category" value="" class="dropdown-toggle btn btn-block btn-default page-controls category-control text-left" type="button" data-toggle="modal" data-target="#categoryChooser">Category
				<i class="fa fa-caret-down" aria-hidden="true"></i>
			</button>


		</div>
	</div>
</row>

<row>
	<div class="col-md-12">
	    <input id="price" class="form-control input-lg inputs" type=text placeholder="$">
	</div>
</row>
<row>
	<div class="col-md-12">
			<input id="itemDescription" class="form-control input-lg inputs" type="text" placeholder="Item Description (Optional)">
	</div>
</row>

<row class="col-xs-12">
	<div class="box">
	    <center>
            <label id="colorLabel" class="text-center label-text" style="margin-bottom: 0px;">Color Codes</label>
            <p>
                <label class="text-center label-text" style="font-size: 300%; margin-top: 0px; padding-top: 0px;">Selected Color Code: </label>
                <button class="label-text" id="selectedColorCode" data-toggle="modal" data-target="#colorChooser" value="{{.SelectedColorCode}}" style="border: solid; font-size: 400%; background-color: {{.SelectedColorCodeHtml}}; padding-top: 0px; padding-top: 15px; width: 200px; margin-left: 20px; border-radius: 50px;">&nbsp&nbsp&nbsp;</button>
            </p>
	    </center>

		<p>
		    <label class="sublabel-text">Current discounts: {{FncGlobalDiscount1}}</label>
		</p>
	</div>
</row>

</div>

<div class="copyright text-center" style="height: 60px;">
	<p>{{.CopyRight}} </p>
</div>

</body>
</html>
