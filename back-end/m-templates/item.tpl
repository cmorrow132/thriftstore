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

            var licenseDaysLeft={{.LicenseDaysLeft}};
            if(licenseDaysLeft < 30) {
                $('#licenseWarning').text("License expires in " + licenseDaysLeft + "days");
            }

		            var pageType="{{.PageType}}";
		            switch(pageType) {
		                case "newItem":
		                    $('#bCodeBtn').addClass('clsDisableBtn');
		                    $('#bCodeBtn').attr('disabled','disabled');
                            break;
                        case "exItem":
                            $('#selected_category').attr('disabled','disabled');
                            $('#price').attr('disabled','disabled');
                            $('#itemDescription').attr('disabled','disabled');
                            $('#selectedColorCode').attr('disabled','disabled');
                            $('#ExItemApply').attr('disabled','disabled');
                            $('#ExItemApply').addClass('clsDisableBtn');

                            $('#bCodeID').removeAttr('disabled');
                            break;
		            }
``
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
                            if($('#bCodeID').val() != "" ) {
                                postData = "bcode=" + $('#bCodeID').val();
                                $.ajax({                                                                    //Send data to the back end
                                    url: '/lookupItem',
                                    type: 'post',
                                    dataType: 'text',
                                    data: postData,
                                    success: function (data) {
                                        var returnData=data.substring(0,5);

                                        if(returnData!="Error") {                                           //Populate fields with item data
                                            returnData=data.split("|");

                                            var catID=returnData[0];
                                            var discount=returnData[1];
                                            var description=returnData[2];
                                            var price=returnData[3];
                                            var colorcode=returnData[4];
                                            var catName=returnData[5];


                                            $("#selected_category").val(catID);               //Set value on label for selected category
                                            $("#selected_category").text(catName);
                                            $("#priceInputLabel").text(price);                  //Set the input price and simulate
                                            $('#btnPriceSubmit').click();                       //click on price input dialog

                                            $('#itemDescription').val(description);

                                            $("#selectedColorCode").val(discount);             //Set value on #SelectedColorCode
                                            $("#selectedColorCode").css('background-color',colorcode);  //Set the color code for this discount ID

                                            //Reenable the input fields
                                            $('#selected_category').removeAttr('disabled');
                                            $('#price').removeAttr('disabled');
                                            $('#itemDescription').removeAttr('disabled');
                                            $('#selectedColorCode').removeAttr('disabled');

                                            $('#bCodeBtn').removeClass('clsScanCode');
                                            $('#bCodeBtn').addClass('clsDisableBtn');
                                            $('#bCodeBtn').attr('disabled','disabled');

                                            $('#bCodeID').attr('disabled','disabled');

                                        }
                                        else {
                                            $('#bCodeID').val("");
                                            $("#warningTitle").text("Error");                   //Open the error msg modal
                                            $('#warningMsg').text(data);
                                            $("#dlgHeader").removeClass("btn-success");
                                            $("#dlgHeader").addClass("btn-danger");
                                            $("#dlgProgressSpinner").hide();
                                            $("#dlg-btn").show();
                                            $('#warningBox').modal({
                                                backdrop: 'static',
                                                keyboard: false,
                                                show: true
                                            });
                                        }
                                    }
                                });
                            }
                            else {
                                alert("open scan module");
                            }
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
                                        //$('#selectedColorCode').attr('disabled','disabled');


                                    }
                                }
                            });
                            /*alert("Printing bar code");
                            $('#btnReload').addClass('clsDisableBtn');
                            $('#btnReload').attr('disabled','disabled');

                            //$(this).removeClass('clsPrintCode');
                            $(this).addClass('clsDisableBtn');
                            $(this).attr('disabled','disabled');*/
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

                        if(getPriceValue()>0) {
                            if(pageType=="newItem") {       //if a category was selected and price is greater than 0
                                $('#bCodeBtn').removeClass('clsDisableBtn');        //enable the barcode button
                                $('#bCodeBtn').removeAttr('disabled');
                            }
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
                            keyboard: false,
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
                            if(pageType=="newItem") {
                                $('#bCodeBtn').removeClass('clsDisableBtn');                        //enable the barcode button for new item pages
                                $('#bCodeBtn').removeAttr('disabled');
                            }
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
                    //############ HOME PAGE BUTTON CLICKED #######################//
                    $('#homeButton').click(function () {

                        bCodeBtnColor=$('#bCodeBtn').css('background-color');
                        submitBtnColor=$('#NewItemApply').css('background-color');

                        if(pageType=="exItem") {
                            $(location).attr('href', '{{.MobOrPcHomeBtn}}');
                        }
                        else {
                            //Bar code printed, but item not submitted yet
                            if ($('#bCodeBtn').hasClass("clsPrintCode") && bCodeBtnColor == "rgb(192, 192, 192)" && submitBtnColor == "rgb(5, 180, 0)") {
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

                            //Values changed, bar code not printed, but item has not been added
                            else if (submitBtnColor == "rgb(5, 180, 0)") {
                                if (getPriceValue() > 0 || $('#selected_category').val() != "") {
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

                        else if($('#bCodeID').val()=="" || $('#selected_category').val()==""  || priceTotal==0 || $('#selectedColorCode').val()=="none-selected")      //Some fields incomplete
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
                            var postData="config=new&bcode\="+ $('#bCodeID').val()+"&category\="+$("#selected_category").val()+"&price\="+price+"&description\="+$('#itemDescription').val()+"&colorcode\="+$('#selectedColorCode').val();

                            $.ajax({                                                                    //Send data to the back end
                                url: '/configProduct',
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
                        $("#warningTitle").text("Updating Product");                              //Data was entered appropriately
                        $('#warningMsg').text("Updating product data.");        //Set msg adding products
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
                        var postData="config=ex&bcode\="+ $('#bCodeID').val()+"&category\="+$("#selected_category").val()+"&price\="+price+"&description\="+$('#itemDescription').val()+"&colorcode\="+$('#selectedColorCode').val();
                        $.ajax({                                                                    //Send data to the back end
                            url: '/configProduct',
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

                                    $(location).attr('href', '{{.MobOrPcHomeBtn}}/get-item')                           //Item added, reload blank new item page
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
			padding-bottom: 20px;
			margin-bottom: 20px;
			font-weight: normal;
			padding-left: 20px;
			padding-top: 15px;
		}

        .discountlabel-text {
            font-family: Arial, Helvetica, Monospace;
            font-size: 60px;
            font-weight: normal;
            padding-left: 20px;
            width: 100px;
            border-radius: 50%;
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
			padding-right: 10px;
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
            height: 150px;
            border-radius: 50px;
            border: solid;
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

        .numberBox {
            width: auto;
        }

		.number-buttons {
			border-radius: 5px;
			border: 1px;
			border-style: solid;
			//height: 120px;

			<!-- padding-bottom: 50px; //-->
			font-family: Arial, Helvetica, Monospace;
			font-size: 120px;
			border: solid;
			margin-right: 10px;
			padding-left: 70px;
			padding-right: 70px;
			margin-bottom: 10px;
			background-color: #adc0d0;
		}

        .numberboxValue {
			border-radius: 5px;
			border: 2px;
			border-style: solid;
			font-family: Arial, Helvetica, Monospace;
			font-size: 120px;
			border: solid;
			margin-left: 30px;
			margin-right: 20px;
			margin-bottom: 10px;
			padding-left: 20px;
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
            <div id="colorOptions" class="box-noborder" style="padding-left: 20px;">
                <div class="btn-group" data-toggle="buttons">
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
          <h4 class="modal-title text-center" style="font-size: 50px;">Choose a category for this item<p>(Swipe up and down for more)</p></h4>
      </div>
      <div class="modal-body">
            <div class="categorybox-noborder" style="height: 800px; overflow: scroll;">
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


<div id="numberBox" class="modal fade" role="dialog" data-backdrop="true">
    <div class="modal-dialog modal-lg" style="width: 80%;">
        <div class="modal-content" style="width: 100%;">
            <div class="modal-header btn-primary" style="padding-top: 10px; padding-bottom: 10px;">
                <h4 class="modal-title label-text text-center dlglabel-text">Price Input</h4>
            </div>
            <div class="modal-body" style="width: 100%;">
                <label id="priceInputLabel" class="numberboxValue" style="width: 55%;"></label>
                <button id="btnPriceSubmit" class="number-buttons fa fa-arrow-right btn-success" style="background-color: #5cb85c; padding-top: 25px; padding-bottom: 30px; border: 2px solid;"></button>
                <center>
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
                    <button id="btnPriceBkspc" class="btn number-buttons fa fa-arrow-left" style="background-color: #f0ad4e; color: white;"></button>
                </p>
                </center>
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
	    <input id="price" class="form-control input-lg inputs" type=text placeholder="$" value="{{.ItemPrice}}">
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
                <button class="label-text" id="selectedColorCode" data-toggle="modal" data-target="#colorChooser" value="none-selected" style="background-color: rgb(15,15,15); border: solid; font-size: 400%; padding-top: 0px; padding-top: 15px; width: 200px; margin-left: 20px; border-radius: 50px;">&nbsp&nbsp&nbsp;</button>
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
