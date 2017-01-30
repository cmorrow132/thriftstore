<script>
    var lastButton;

    $(document).on('click',"[name=color]",function(event) {
        $('#colorDiscountData').removeAttr('hidden');
        event.stopImmediatePropagation();

        if(lastButton != undefined) {
            lastButton.css('border','1px solid');
            lastButton.css('border-radius','4px');
        }
        lastButton=$(this);
        $(this).css('border','5px solid');
        $(this).css('border-radius','50%');
       //alert($(this).css('backgroundColor'));

        $('#selectedColorButton').css('background-color',$(this).css('background-color'));
        postData="id=" + $(this).val();
        $.ajax({
            //Send data to the back end
            url: '/getConfigDiscounts',
            type: 'post',
            dataType: 'text',
            data: postData,
            success: function (data) {                          //AJAX request completed, deal with the results below
                $('#colorDiscount').val(data);

                var prependSign="";

                var discountNumeric=parseFloat(data);
                if(discountNumeric != 0) {

                    var discountSplit=data.split(".");
                    var dollarAmount=parseInt(discountSplit[0]);
                    var centAmount=parseInt(discountSplit[1]);

                    if(dollarAmount!=0) {
                        $('#colorDiscount').val("$" + data);
                    }
                    else {
                        $('#colorDiscount').val(centAmount + "%");
                    }
                }
            }
        });
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
        <button id="btnSaveDiscountData" class="btn btn-primary text-center pull-right" style="margin-left: 20px; font-size: 25px;" disabled>Save</button>
        <p>
            <label class="dynContent-label-text" style="font-size: 25px; margin-bottom: 10px;">Senior Discount: </label>
            <input type="text" class="cmd-dlglabel-text" id="seniorDiscount" placeholder="$ / %" style="margin-left: 27px; padding-left: 10px; width: 100px; margin-bottom: 10px;">
        </p>
        <p>
            <label class="dynContent-label-text" style="font-size: 25px; padding-top: 0px;">Military Discount: </label>
            <input type="text" class="cmd-dlglabel-text" id="militaryDiscount" placeholder="$ / %" style="margin-left: 20px; padding-left: 10px; width: 100px; margin-bottom: 10px;">
        </p>
        <p><label class="dynContent-label-text" style="font-size: 25px;">Defined discount tags: </label>
            {{GetDiscounts}}
        </p>
        <p>
        <p>
            <label class="dynContent-label-text" style="font-size: 25px;">Click a color to set its discount value</label>
        </p>
        <p style="padding-left: 20px;">
            {{GetColors}}

        <div id="colorDiscountData" style="margin-left: 20px; margin-top: 30px;" hidden>
            <label class="dynContent-label-text" style="font-size: 25px;">Discount: </label>
            <input id="colorDiscount" class="dynContent-label-text" style="font-size: 25px; margin-left: 10px; padding-left: 10px; padding-top: 0px;">
            <button class="discountlabel-text" id="selectedColorButton">&nbsp;</button>
        </div>
        </p>
    </div>

</p>