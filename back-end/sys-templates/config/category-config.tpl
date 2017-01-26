<script>

    $(document).on('click',"[name=removeCategory]",function(event) {
        event.stopImmediatePropagation();
        var selectedCategory=$(this).data("value").toString();

        var catID="";
        var newCatItem=selectedCategory.substring(0,7);

        if(newCatItem != "newcat-") {
            $('#removeCatList').append(selectedCategory + ",");       //Hidden label to store deleted category names to send to server
            catID=".cat-" + selectedCategory;
        }
        else {
            catID="." + selectedCategory;
        }

        $(this).remove();
        $(catID).remove();
        var itemToRemove=$(this).attr('id')+",";

        $('#newCatList').text($('#newCatList').text().replace(itemToRemove,""));
        $('#CategorySaveBtn').removeAttr('disabled');

    });

    $('#newCategoryName').keyup(function() {
       if($(this).val() != "" && $(this).val().length>=2) {
           $('#newCategoryAddBtn').removeAttr('disabled');
       }
       else {
           $('#newCategoryAddBtn').attr('disabled','disabled');
       }
    });

    $('#newCategoryAddBtn').click(function() {
        $('#categoryList li').each(function(idx,li) {

            alert($(li));
        });

        $('#newCatList').append($('#newCategoryName').val()+",");         //Hidden label to store new category names to send to server
        var catID="newcat-" + Math.ceil(Math.random()*999999999);
        $('#categoryList').append("<p><i name='removeCategory' data-value='" + catID + "' id='" + $('#newCategoryName').val() + "' class='fa fa-times-circle-o' style='color: #337ab7; margin-right: 10px;'> </i><label class='" + catID + "'>" + $('#newCategoryName').val() + "</label></p>\n");
        $('#newCategoryName').val("");
        $(this).attr('disabled','disabled');
        $('#CategorySaveBtn').removeAttr('disabled');
    });

    $('#CategorySaveBtn').click(function() {
        var postData="removeCategories="+$('#removeCatList').text() + "&addCategories=" + $('#newCatList').text();
        $.ajax({                                                                    //Send data to the back end
            url: '/saveCategories',
            type: 'post',
            dataType: 'text',
            data: postData,
            success: function (data) {                          //Populate user details
                if (data == "Success") {
                    $.ajax({                                                                    //Send data to the back end
                        url: '/getConfig/categories',
                        type: 'post',
                        dataType: 'text',
                        data: "",
                        success: function (data) {                          //AJAX request completed, deal with the results below
                            $('#main-content').html("");
                            $('#serverMsg').text("");
                            $('#main-content').html(data);

                        }
                    });
                }
                else {
                    $('#serverMsg').html("<font color='#d9534f'>" + data + "</font>");
                }
            }
        });
    });

</script>

<style>
    #newCategoryName {
        width: 300px;
        margin-left: 20px;
        padding-left: 20px;
    }

</style>

<p>
    <span class="underline">
        <label class="dynContent-label-text">Categories</label>
    </span>
</p>

<p>
<div class="form-horizontal" style="margin-top: 20px;">
    <input id="newCategoryName" class="dynContent-sublabel-text" placeholder="New category name">
    <button id="newCategoryAddBtn" class="btn btn-primary" style="font-size: 20px; margin-left: 10px;" disabled>Add</button>
    <button id="CategorySaveBtn" class="btn btn-primary" style="font-size: 20px; margin-left: 10px;" disabled>Save</button>
    <label id="serverMsg" class="dynContent-sublabel-text" style="float: right; margin-right: 50px;"></label>
    <p><label id="newCatList" hidden></label></p>
    <p><label id="removeCatList" hidden></label></p>
</div>

<div class="tplSubContentDetail">
    <ul id="categoryList" class="dynContent-sublabel-text">
    {{CategoryList}}
    </ul>
</div>