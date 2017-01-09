<html>
<head>
	<title>{{.ActionTitle}}</title>

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

	<!--<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" type="text/css">-->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript"></script>

	<script src="http://code.jquery.com/jquery-1.4.1.min.js"></script>
    <link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel='stylesheet' type='text/css'>

	<script>
		$(document).ready(function() {

			$("#bCodeBtn").click(function () {
			    $(this).blur();
			    if($(this).hasClass('clsNewCode')) {
                    $.ajax({
                        url: '/mkBarCode',
                        type: 'get',
                        dataType: 'html',
                        data : { ajax_post_data: ''},
                        success : function(data) {
                            $('#bCodeID').val(data);
                            $('#bCodeBtn').text(' Print');
                            $('#bCodeBtn').removeClass('clsNewCode');
                            $('#bCodeBtn').addClass('clsPrintCode');
                            $('#bCodeBtn').removeAttr("selected");
                        }
                    });
                }
                else if($(this).hasClass('clsScanCode')) {
                    alert("Scanning bar code");
                }
                else if($(this).hasClass('clsPrintCode')) {
                    alert("Printing bar code");
                }
			});

			$("#btnReload").click(function () {
				location.reload();
			});

            $("#SelectedColorCode").click(function () {
                if($("#colorOptions").hasClass('hidden')) {
                    $("#colorOptions").removeClass('hidden');
                    $("#colorOptions").addClass('visible');
                }
                else {
                    $("#colorOptions").removeClass('visible');
                    $("#colorOptions").addClass('hidden');
                }
            });

            $("[name=color]").click(function() {
                var itemClicked=$(this).val();
                //alert(itemClicked);
                $("#SelectedColorCode").val(itemClicked);
                //$("#SelectedColorCode").text(itemClicked);
                $("#SelectedColorCode").css('background-color',$(this).css('background-color'));

                $("#colorOptions").removeClass('visible');
                $("#colorOptions").addClass('hidden');
            });

            $("[name=categoryName]").click(function () {
                var itemClicked=$(this).val();
                $("#selected_category").val(itemClicked);
                $("#selected_category").text(itemClicked);
            });

			$('#price').click(function () {
                var price=$("#price").val();
                var priceCents="";
                var pricePlaceholder=price.split(".");
                var priceDollar=pricePlaceholder[0].substr(1,pricePlaceholder[0].length)
                if(pricePlaceholder[1]) {
                    priceCents=pricePlaceholder[1];
                }
                else {
                    priceCents="00";
                }

                var priceModifier="$"+priceDollar+"."+priceCents
                //alert(pricePlaceholder[1]);
                $('#price').val(priceModifier);
			});

            $('#NewItemApply').click(function () {
                //Check that all fields are completed
                var price=$("#price").val();
                var priceTotal=parseFloat(price.substr(1,price.length));
                if(!priceTotal) { priceTotal=0; }

                if($('#bCodeID').val()=="" || $('#selected_category').val()==""  || priceTotal==0)
                {
                    alert("Complete all fields before submitting");
                }
                else {
                    alert("Adding product");
                }
            });

            $('#ExItemApply').click(function () {
                alert("Updating existing item");
            });

			$.fn.setCursorPosition = function(pos) {
              this.each(function(index, elem) {
                if (elem.setSelectionRange) {
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
			<!-- padding-right: 50px; -->
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

		.categorySelections {
		    border: none;
		    background-color: white;
		    padding-left: 50px;
		}

	</style>
</head>

<body>

<div class="container">
<div id="colorChooser" class="modal fade" role="dialog" data-backdrop="true">
  <div class="modal-dialog modal-lg" style="width: 90%;">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
            <h4 class="modal-title text-center" style="font-size: 50px;">Choose a color code for this item</h4>
      </div>
      <div class="modal-body">
            <div id="colorOptions" class="box-noborder hidden">
                <div class="btn-group color-buttons" data-toggle="buttons">
                    <div id="colorButtonGroup">
                        <button class="color-buttons btn btn-cons active" data-dismiss="modal" style="border: solid; border-radius: 50px; background-color: white !important;" name="color" value="white">
                            White
                        </button>
                        <button class="color-buttons btn btn-cons active" data-dismiss="modal" style="border: solid; border-radius: 50px; background-color: orange !important;" name="color" value="orange">
                            Orange
                        </button>
                        <button class="color-buttons btn btn-cons active" data-dismiss="modal" style="border: solid; border-radius: 50px; background-color: #45b0ff !important;" name="color" value="blue">
                            Blue
                        </button>
                        <button class="color-buttons btn btn-cons active" data-dismiss="modal" style="border: solid; border-radius: 50px; background-color: #ea2232 !important;" name="color" value="red">
                            Red
                        </button>
                        <button class="color-buttons btn btn-cons active" data-dismiss="modal" style="border: solid; border-radius: 50px; background-color: yellow !important;" name="color" value="yellow">
                            Yellow
                        </button>
                        <button class="color-buttons btn btn-cons active" data-dismiss="modal" style="border: solid; border-radius: 50px; background-color: pink !important;" name="color" value="pink">
                            Pink
                        </button>
                    </div>
                </div>
            </div>
      </div>

    </div>

  </div>
</div>
</div>

<row class="col-md-12">
	<button class="btn btn-block btn-success text-center label-text" style="background-color: #00274D;">{{.ActionTitle}}</button>
</row>

<div class="container-fluid main-content">

<row>
	<div class="col-xs-4">
		<button onclick="location.href = '/';" class="btn btn-block btn-primary fa fa-home page-controls header-buttons"></button>
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
			<button id="selected_category" value="" class="dropdown-toggle btn btn-block btn-default page-controls category-control text-left" type="button" data-toggle="dropdown">Category
				<i class="fa fa-caret-down" aria-hidden="true"></i>
			</button>

			<ul class="dropdown-menu category-data" role="menu">
				<!--
					This will include a list of <li></li> items generated from the backend database
					Might use jquery to do this instead of a template tag
				-->

				{{FnMbiTrkc}}
			</ul>
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
			<input class="form-control input-lg inputs" type="text" placeholder="Item Description (Optional)">
	</div>
</row>

<row class="col-xs-12">
	<div class="box">
	    <center>
            <label id="colorLabel" class="text-center label-text" style="margin-bottom: 0px;">Color Codes</label>
            <p>
                <label class="text-center label-text" style="font-size: 300%; margin-top: 0px; padding-top: 0px;">Selected Color Code: </label>
                <label class="label-text" id="SelectedColorCode" data-toggle="modal" data-target="#colorChooser" value="{{.SelectedColorCodeName}}" style="border: solid; font-size: 400%; background-color: {{.SelectedColorCode}}; padding-top: 0px; padding-top: 15px; width: 200px; margin-left: 20px; border-radius: 50px;">&nbsp&nbsp&nbsp;</label>
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
