<script>
    var lastButton;

    $('#seniorDiscount').val($('#seniorDiscountLbl').text() + "%" );
    $('#militaryDiscount').val($('#militaryDiscountLbl').text() + "%");

    var seniorDiscount=$('#seniorDiscountLbl').text();
    var militaryDiscount=$('#militaryDiscountLbl').text();
    var colorDiscount;

    $(document).on('click',"[name=color]",function(event) {
        $('#btnSaveDiscountData1').hide();
        $('#btnSaveDiscountData2').attr('disabled','disabled');

        $('#colorDiscountData').removeAttr('hidden');
        event.stopImmediatePropagation();

        if (lastButton != undefined) {
            lastButton.css('border', '1px solid');
            lastButton.css('border-radius', '4px');
        }
        lastButton = $(this);
        $(this).css('border', '5px solid');
        $(this).css('border-radius', '50%');
        //alert($(this).css('backgroundColor'));

        $('#selectedColorButton').css('background-color', $(this).css('background-color'));
        postData = "id=" + $(this).val();
        $.ajax({
            //Send data to the back end
            url: '/getConfigDiscounts',
            type: 'post',
            dataType: 'text',
            data: postData,
            success: function (data) {                          //AJAX request completed, deal with the results below
                $('#colorDiscount').val(data + "%");
                colorDiscount=data;
            }
        });
    });


    $(document).on('click','#seniorDiscount', function(event) {
        event.stopImmediatePropagation();
        $(this).val("");
        $('#btnSaveDiscountData1').show();
        $('#colorDiscountData').attr('hidden','hidden');

    });

    $(document).on('focusout','#seniorDiscount', function(event) {
        event.stopImmediatePropagation();
        if ($(this).val() != "") {
            seniorDiscount=$(this).val();
        }
        $('#seniorDiscount').val(seniorDiscount + "%");
    });

    $(document).on('keyup','#seniorDiscount', function(event) {
        event.stopImmediatePropagation();
        var chars = /[0-9]/i;
        var value=$(this).val();
        var char=value[value.length-1];
        if(!chars.test(char)) {
            $(this).val(value.substring(0,value.length-1));
        }

        if( $(this).val()!="") {
            $('#btnSaveDiscountData1').removeAttr('disabled');
        }
        else {
            $(this).val(seniorDiscount + "%");
        }
    });

    $(document).on('click', '#militaryDiscount', function(event) {
        event.stopImmediatePropagation();
        $(this).val("");
        $('#btnSaveDiscountData1').show();
        $('#colorDiscountData').attr('hidden','hidden');

    });

    $(document).on('focusout','#militaryDiscount', function(event) {
        event.stopImmediatePropagation();
        if ($(this).val() != "") {
            militaryDiscount=$(this).val();
        }
        $('#militaryDiscount').val(militaryDiscount + "%");
    });

    $(document).on('keyup','#militaryDiscount', function(event) {
        event.stopImmediatePropagation();
        var chars = /[0-9]/i;
        var value=$(this).val();
        var char=value[value.length-1];
        if(!chars.test(char)) {
            $(this).val(value.substring(0,value.length-1));
        }

        if( $(this).val()!="") {
            $('#btnSaveDiscountData1').removeAttr('disabled');
        }
        else {
            $(this).val(militaryDiscount + "%");
        }
    });

    $(document).on('click','#colorDiscount', function(event) {
        event.stopImmediatePropagation();
        $(this).val("");
    });

    $(document).on('keyup','#colorDiscount', function(event) {
        event.stopImmediatePropagation();
        var chars = /[0-9]/i;
        var value=$(this).val();
        var char=value[value.length-1];
        if(!chars.test(char)) {
            $(this).val(value.substring(0,value.length-1));
        }

        if( $(this).val()!="") {
            $('#btnSaveDiscountData2').removeAttr('disabled');
        }
        else {
            $(this).val(colorDiscount);
            $('#btnSaveDiscountData2').attr('disabled','disabled');
        }
    });

    $(document).on('focusout','#colorDiscount', function(event) {
        event.stopImmediatePropagation();
        if ($(this).val() != "") {
            colorDiscount=$(this).val();
        }
        $('#colorDiscount').val(colorDiscount + "%");
    });

    $('#btnSaveDiscountData1').click(function() {
       alert("Senior: " + seniorDiscount + "\nmilitary: " + militaryDiscount);
    });

    $('#btnSaveDiscountData2').click(function() {
        alert("Color discount: " + colorDiscount);
    });

</script>

<style>
    .cmd-dlglabel-text {
        font-family: Arial, Helvetica, Monospace;
        font-size: 20px;
        font-weight: normal;
        padding-left: 20px;
        margin-bottom: 10px;

    }

    .color-buttons {
        width: 40px;
        height: 30px;
        margin-right: 10px;
        border: 1px solid;
    }

    .discountlabel-text {
        font-family: Arial, Helvetica, Monospace;
        font-size: 20px;
        font-weight: normal;
        padding-left: 20px;
        width: 65px;
        border-radius: 10px;
    }

</style>

<p>
    <span class="underline">
        <label class="dynContent-label-text">Discounts</label>
    </span>
</p>

<p>
    <div class="tplSubContentDetail" id="discountContent" style="padding-top: 15px;">
        <p>
            <label class="dynContent-label-text" style="font-size: 25px; margin-bottom: 10px;">Senior Discount: </label>
            <input type="text" class="cmd-dlglabel-text" id="seniorDiscount" placeholder="%" style="margin-left: 27px; padding-left: 10px; width: 100px; margin-bottom: 10px;">
        </p>
        <p>
            <label class="dynContent-label-text" style="font-size: 25px; padding-top: 0px;">Military Discount: </label>
            <input type="text" class="cmd-dlglabel-text" id="militaryDiscount" placeholder="%" style="margin-left: 20px; padding-left: 10px; width: 100px; margin-bottom: 10px;">
        </p>
        <p><label class="dynContent-label-text" style="font-size: 25px;">Defined discount tags: </label>
            {{GetDiscounts}}
        </p>
        <p>
            <label class="dynContent-label-text" style="font-size: 25px;">Click a color to set its discount value</label>
        </p>
        <p style="padding-left: 20px;">
            {{GetColors}}

            <button id="btnSaveDiscountData1" class="btn btn-primary text-center pull-right" style="margin-left: 20px; font-size: 25px;" disabled>Save</button>
        <div id="colorDiscountData" style="margin-left: 20px; margin-top: 30px;" hidden>
            <label class="dynContent-label-text" style="font-size: 25px;">Discount: </label>
            <input id="colorDiscount" class="dynContent-label-text" style="width: 90px; font-size: 25px; margin-left: 10px; padding-left: 10px; padding-top: 0px; margin-right: 0px; padding-right: 0px;">

            <button class="discountlabel-text" id="selectedColorButton" style="margin-left: 20px;">&nbsp;</button>
            <button id="btnSaveDiscountData2" class="btn btn-primary text-center" style="margin-left: 50px; font-size: 25px;" disabled>Save</button>
        </div>
        </p>
    </div>

</p>