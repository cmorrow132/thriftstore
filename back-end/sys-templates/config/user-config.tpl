<script>
    $("[name=user]").click(function() {
        $('#usersDropdown').text($(this).text());   //Change dropdown to selected username
        $('#selectedUserName').text($(this).text());
        $.ajax({                                                                    //Send data to the back end
            url: '/getUserDetails',
            type: 'post',
            dataType: 'text',
            data: "user=" + $(this).text(),
            success: function (data) {                          //Populate user details
                $('#groupList').text(data);
            }
        });

        $('#userContent').removeAttr('hidden');

    });
</script>

<p>
    <span class="underline">
        <label class="dynContent-label-text">Users</label>
    </span>
</p>

<p>
    <div class="form-horizontal">

        <label class="dynContent-sublabel-text" style="width: 200px;">Select a user</label>

        <div class="dropdown" style="display: inline; padding-bottom: 20px;">
            <a id="usersDropdown" class="dropdown-toggle btn btn-default menu-dropdown text-left" style="margin-right: 10px; margin-top: 5px; padding-top: 0px; padding-bottom: 0px;" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">User <span class="caret"></span></a>
            <ul class="dropdown-menu">
                {{GetUserList}}
            </ul>
        </div>
    </div>
</p>

<p>
    <div class="tplSubContentDetail" id="userContent" hidden="hidden">
        <p>
            <label class="dynContent-sublabel-text">Username: </label><label id="selectedUserName" class="dynContent-sublabel-text" style="padding-left: 20px;"></label>
        </p>
        <p>
            <label class="dynContent-sublabel-text">Groups: </label><label id="groupList" class="dynContent-sublabel-text" style="padding-left: 20px;"></label>
        </p>
    </div>
</p>
