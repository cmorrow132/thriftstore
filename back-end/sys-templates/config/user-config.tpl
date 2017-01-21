<script>
        $("[name=user]").click(function() {
            var userGroups = "";

            $('#serverMsg').text("");

            $('#usersDropdown').text($(this).text());   //Change dropdown to selected username
            $('#selectedUserName').text($(this).text());
            $.ajax({                                                                    //Send data to the back end
                url: '/getUserDetails',
                type: 'post',
                dataType: 'text',
                data: "user=" + $(this).text(),
                success: function (data) {                          //Populate user details
                    $('#groupList').text("");
                    $('#updatedGroups').text("");

                    var groupList = data.split("|");
                    for (var i = 0; i < groupList.length - 1; i++) {
                        if (groupList[i] == "none") {
                            //userGroups="None"
                            $('#updatedGroups').append("none|")
                            $('#groupList').append("None");
                        }
                        else {
                            //userGroups=userGroups+groupList[i]+",";
                            $('#updatedGroups').append(groupList[i] + "|");
                            $('#groupList').append("<span style='margin-right: 20px;'><i name='remove' data-value=\"" + groupList[i] + "\" class='fa fa-times-circle-o' style='color: #337ab7;'> </i> " + groupList[i] + "</span>\n");
                        }
                    }
                }
            });

            $('#userContent').removeAttr('hidden');
        });

        $('#saveUserData').click(function() {
            $('#serverMsg').text("");
            var user=$('#selectedUserName').text();
            var groupList=$('#updatedGroups').text();

            $.ajax({                                                                    //Send data to the back end
                url: '/saveUserDetails',
                type: 'post',
                dataType: 'text',
                data: "user=" + user + "&groups=" + groupList,
                success: function (data) {                          //Populate user details
                    if(data=="Success") {
                        $('#serverMsg').html("<font color='blue'>User data saved.</font>");
                    }
                    else {
                        $('#serverMsg').html("<font color='#d9534f'>" + data + "</font>");
                    }
                }
            });
        });

        $(document).on('click',"[name=remove]",function() {
            $('#serverMsg').text("");

            var selectedGroup=($(this).data("value"));
            if($('#updatedGroups').text() != "none|") {
                var groupListSplit=$('#updatedGroups').text().split("|");
                $('#groupList').text("");
                $('#updatedGroups').text("");

                for(var i=0;i<groupListSplit.length-1;i++) {
                   if(selectedGroup != groupListSplit[i]) {
                       $('#updatedGroups').append(groupListSplit[i]+"|");
                       $('#groupList').append("<span style='margin-right: 20px;'><i name='remove' data-value=\"" + groupListSplit[i] + "\" class='fa fa-times-circle-o' style='color: #337ab7;'> </i> " + groupListSplit[i] + "</span>\n");
                   }
                }
            }


            if($('#updatedGroups').text().length==0) {
                $('#updatedGroups').text("none|");
                $('#groupList').append("None");
            }
        });
</script>

<style>
    .close {
        font-size: 24px;
        padding:0 16px 0 0; /* whatever the dimensions the image needs */
        background-image: url('/Public/images/remove.png') no-repeat right center; /* Position left/right/whatever */
    }

    .right {
        position: absolute;
        right: 0px;
        width: 300px;
        border: 3px solid #73AD21;
        padding: 10px;
    }

    .successTest {
        color: #337ab7;
    }

    .errorText {
        color: #d9534f;
    }

</style>
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
        <p>
            <label id="updatedGroups" hidden></label>
        </p>
        <p style="margin-top: 30px;">
            <span>
                <label id="serverMsg" class="dynContent-sublabel-text" style="float: left;"></label>
                <button id="saveUserData" class="btn btn-primary dynContent-sublabel-text" style="float: right; margin-right: 20px;">Save</button>
            </span>
        </p>

        <span>
            <label class="dynContent-sublabel-text" style="font-size: 20px;">Group Descriptions: {{GetGroupList}}</label>
        </span>

    </div>
</p>
