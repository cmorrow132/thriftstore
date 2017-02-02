<script>
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
        var postData="license="+$('#licenseInput').val();
        $.ajax({                                                                    //Send data to the back end
            url: '/updateLicense',
            type: 'post',
            dataType: 'text',
            data: postData,
            success: function (data) {
                licenseData=data.split(",")
                switch(licenseData[0]) {
                    case "1054":
                        $('#licenseResponseStatus').text("The license serer is down.");
                        break;
                    case "invalid":
                        $('#licenseResponseStatus').text("The license is invalid.");
                        $('#saveLicenseBtn').attr('disabled','disabled');
                        break;
                    case "expired":
                        $('#licenseResponseStatus').text("The license is expired.");
                        $('#saveLicenseBtn').attr('disabled','disabled');
                        break;
                    case "valid":
                        $(location).attr('href','/front/config');
                }
            }
        });
    });
</script>

<div style="padding-top: 20px;">
    <p>
        <label class="dynContent-label-text" style="font-size: 25px; margin-bottom: 0px; margin-left: 0px; padding-bottom: 0px; padding-right: 0px;">Current License: </label>
        <label class="dynContent-label-text" style="font-size: 25px; margin-bottom: 0px; margin-left: 0px; padding-bottom: 0px; padding-right: 0px; margin-right: 0px; padding-right: 0px;">{{.ProdLicense}}, </label>
        <label id="licenseConfigExpiryLbl" class="dynContent-label-text" style="font-size: 25px; margin-bottom: 0px; padding-bottom: 0px; padding-right: 0px;"></label>
    </p><p>
        <label class="dynContent-label-text" style="font-size: 25px; margin-bottom: 0px; padding-bottom: 0px;">New License: </label>
        <label id="licenseLabel" class="dynContent-label-text" style="font-size: 25px; margin-bottom: 0px; padding-bottom: 0px; padding-right: 0px; margin-left: 10px;" hidden></label>
        <input type="text" id="licenseInput" class="cmd-dlglabel-text" style="font-size: 25px; margin-bottom: 0px; padding-bottom: 0px; padding-right: 0px; padding-left: 10px; margin-left: 10px;">
        <button id="saveLicenseBtn" class="btn btn-primary" style="font-size: 20px; margin-left: 10px;" disabled>Save</button>
    </p><p>
        <label id="licenseResponseStatus" class="dynContent-label-text" style="color: #337ab7; font-size: 25px; margin-top: 0px; padding-top: 0px;"></label>
    </p><p>
    </p>

</div>