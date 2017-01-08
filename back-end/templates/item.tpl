<html>
<head>
	<title>{{.ActionTitle}}</title>

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<!--<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" type="text/css">-->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
	<script src="http://code.jquery.com/jquery-1.4.1.min.js"></script>
	<!-- <script src="/getModalScript" type="text/javascript" charset="utf-8"></script> //-->

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

            $("#colorLabel").click(function () {
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

            /*$(".color-buttons").click(function () {
                var itemClicked=$(this);
                alert(itemClicked.attr("value"));
            });*/

			/* $('#price').click(function () {
                var priceValModified="0";
			    var priceValue=$(this).val();
			    $.each(priceValue,function() {
			        if($(this) != "$") {
			            $priceValModified+=$(this);
			        }
			    });
			    alert(priceValModified);
			    $('#price').val(priceValModified);
			}); */
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
			padding-left: 20px;
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
			padding-right: 50px;
		}

        .hidden {
            opacity: 0;
        }
        .visible {
            display: block;
        }

		.colorPicker {
			border-radius: 50px;
			padding-left: 50px;
			border: solid;
			margin-right: 50px;
			height: 10%;
			overflow: scroll;
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

	</style>

</head>

<body>

<row class="col-md-12">
	<button class="btn btn-block btn-success text-center label-text" style="background-color: #00274D;">{{.ActionTitle}}</button>
</row>

<div class="container-fluid main-content">

<row>
	<div class="col-xs-4">
		<button onclick="location.href = '/';" class="btn btn-block btn-primary fa fa-home page-controls header-buttons"></button>
	</div>
	<div class="col-xs-4">
		<button class="btn btn-success btn-block fa fa-check header-buttons page-controls" style="background-color: #05B400;"></button>
	</div>
	<div class="col-xs-4">
		<button id="btnReload" class="btn btn-yellow btn-block fa fa-refresh header-buttons page-controls"></button>
	</div>	
</row>

<row>
	<div class="input-prepend">
			<input id="bCodeID" class="barcode" type="text" placeholder="Produce Code" value="{{.BarCodeID}}" disabled>
			<button id="bCodeBtn" class="btn btn-info barcode-btn fa fa-barcode {{.ClsbCodeBtn}}" aria-hidden="true" style="border: 1px solid black;"> {{.BarcodeBtnLabel}}</button>
	</div>
</row>

<row>
	<div class="col-md-12">
		<div class="dropdown">
			<button class="dropdown-toggle btn btn-block btn-default page-controls category-control text-left" type="button" data-toggle="dropdown">Category
				<i class="fa fa-caret-down" aria-hidden="true"></i>
			</button>

			<ul class="dropdown-menu category-data" role="menu">
				<!--
					This will include a list of <li></li> items generated from the backend database
					Might use jquery to do this instead of a template tag
				-->
				FnMbi-Trk-c
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
	    <p><label class="text-center label-text" style="font-size: 300%; margin-top: 0px; padding-top: 0px;">Selected Color Code: </label>
	    <label class="sublabel-text" id="SelectedColorCode" style="border: solid; font-size: 100%; background-color: white; padding-top: 0px; padding-top: 15px; width: 100px; margin-left: 20px; border-radius: 50px;">&nbsp&nbsp&nbsp;</label>
	    </p>
	 </center>
		<div id="colorOptions" class="box-noborder hidden">
		<p>
		
		<div class="btn-group color-buttons" data-toggle="buttons">
		<div id="colorButtonGroup">
            <button class="color-buttons btn btn-cons active" style="border: solid; border-radius: 50px; background-color: white !important;" name="color" value="white">
                White
            </button>
            <button class="color-buttons btn btn-cons active" style="border: solid; border-radius: 50px; background-color: orange !important;" name="color" value="orange">
                Orange
            </button>
			<button class="color-buttons btn btn-cons active" style="border: solid; border-radius: 50px; background-color: #45b0ff !important;" name="color" value="blue">
                Blue
            </button>
            <button class="color-buttons btn btn-cons active" style="border: solid; border-radius: 50px; background-color: #ea2232 !important;" name="color" value="red">
                Red
            </button>
            <button class="color-buttons btn btn-cons active" style="border: solid; border-radius: 50px; background-color: yellow !important;" name="color" value="yellow">
                Yellow
            </button>
            <button class="color-buttons btn btn-cons active" style="border: solid; border-radius: 50px; background-color: pink !important;" name="color" value="pink">
                Pink
            </button>
		</div>
		</div>
		</p><p>
			<label class="sublabel-text">Discounts: {{.GlobalDiscount1}}, {{.GlobalDiscount2}}</label>
		</div>
	</div>
</row>

</div>

<div class="copyright text-center" style="height: 60px;">
	<p>{{.CopyRight}} </p>
</div>

</body>
</html>
