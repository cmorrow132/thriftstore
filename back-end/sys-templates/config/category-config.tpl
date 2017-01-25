<script>

    $(document).on('click',"[name=removeCategory]",function() {
        var selectedCategory=$(this).data("value");
        var newCatItem=selectedCategory.substring(1,2);
        alert(newCatItem);

        /*if(selectedCategory.substring(0,5) != ".cat--") {
            $('#removeCatList').append(selectedCategory + ",");       //Hidden label to store deleted category names to send to server
        }
        $(this).remove();
        $(catID).remove();
        var itemToRemove=$(this).attr('id')+",";

        $('#newCatList').text($('#newCatList').text().replace(itemToRemove,""));
        $('#CategorySaveBtn').removeAttr('disabled');*/
        /*$.ajax({                                                                    //Send data to the back end
            url: '/removeCategory',
            type: 'post',
            dataType: 'text',
            data: "category=" + selectedCategory,
            success: function (data) {                          //Populate user details
                if(data=="Success") {

                }
                else {
                    $('#serverMsg').html("<font color='#d9534f'>" + data + "</font>");
                }
            }
        });*/
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
        $('#newCatList').append($('#newCategoryName').val()+",");         //Hidden label to store new category names to send to server
        $('#categoryList').append("<p><i name='removeCategory' data-value='newcat-" + Math.random() + "' id='" + $('#newCategoryName').val() + "' class='fa fa-times-circle-o' style='color: #337ab7; margin-right: 10px;'> </i><label class='cat--1'>" + $('#newCategoryName').val() + "</label></p>\n");
        $('#newCategoryName').val("");
        $(this).attr('disabled','disabled');
        $('#CategorySaveBtn').removeAttr('disabled');
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
    <label id="serverMsg" class="dynContent-sublabel-text" style="float: right; margin-right: 50px;">Test</label>
    <p><label id="newCatList"></label></p>
    <p><label id="removeCatList"></label></p>
</div>

<div class="tplSubContentDetail">
    <ul id="categoryList" class="dynContent-sublabel-text">
    {{CategoryList}}
    </ul>
</div>