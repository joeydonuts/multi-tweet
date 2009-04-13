// Common JavaScript code across your application goes here.
  $(document).ready(function(){
//---Function for adding twitter user--
    $("#dialog").dialog({
     autoOpen: false,
     buttons: {
        "Save": function() {
            save_twitter_user(this);
    },
	 "Cancel": function() {
        $(this).dialog("close");
    }
   }
   }
    );
   $('#dialog_link').click(function(){
		$('#dialog').dialog('open');
		return false;
	});
//---Function for adding a group to twitter user
   $("#dialog_twitter_group_add").dialog({
       autoOpen: false,
       buttons: {
       "Save": function(){
        res=save_twitter_group(this)
        if(res == true){
				$(this).dialog("close")
        }
       },
       "Cancel": function(){
        $(this).dialog("close")
       }  
		 }
   });
   $("a[id^='dialog_link_group_add']").click(function(){
       var twit_id=this.id.split(/\_/).pop()
       $("#group_friend_list").html('');
       get_twitter_friends(twit_id);
		$('#dialog_twitter_group_add').dialog('open');
		return false;
	});
//--Function for adding a search
   $("#dialog_search_add").dialog({
       autoOpen: false,
       buttons: {
       "Save": function(){
        z=save_search(this)
        if(z){
          $(this).dialog("close")
        }
       },
       "Cancel": function(){
        $(this).dialog("close")
       }  
		 }
   });
   $('#dialog_link_search_add').click(function(){
		$('#dialog_search_add').dialog('open');
		return false;
	});
/*
   $("a[id^='twitter_dialog']").livequery(function(){
      $(this).click(function(){
		$('#dialog_twitter_config').dialog('open');
		return false;
	});
   });
   $("#search_config_link").click(function(){
		$('#dialog_search_config').dialog('open');
		return false;
	});
   $("a[id^='search_dialog']").click(function(){
		$('#dialog_search_config').dialog('open');
		return false;
	});
*/
   $("#tabs").tabs();

  })
//--------------------------End of document ready function------------------------------
  function save_search(caller){
    var search_name=validate_text_field('search_name')
    if(!search_name){
         notify("Please enter a valid name for the search")
         return false
    }
    var search_term=validate_text_field('search_term')
    if(!search_term){
         notify("Please enter a valid search term")
         return false
     }
     $.post("../searches/new",{ search_name : search_name, search_term : search_term },
        function(data){
            notify(data);
        });
     return true
  }
  function save_twitter_user(caller){
   var twitter_name=$("#twitter_user").attr('value');
   var twitter_password=$("#twitter_password").attr('value');
   var twitter_password_confirmation=$("#twitter_password_confirmation").attr('value');
   if((twitter_password_confirmation != twitter_password) || twitter_password == '') {
			notify("Passwords Don't Match!");
         return false;
   }
    $(caller).dialog('close');
    $.post("../twits/create",{ twitter_name : twitter_name, twitter_password : twitter_password},
    function(data){
			notify(data);
			$("#twitter_users").append('<p>' + twitter_name + '</p>');         
    }
   );
  }
    function get_twitter_friends(id){
       $.post("../twits/list_friends",{ twit_id : id },
       function(data){
       $("#group_friend_list").html(data);
	 });
     return false
    }
    function save_twitter_group(caller){
    group_name=validate_text_field('group_name')
    if( !group_name){
			notify('Please enter a valid name for the group<span style="color: red"> [must have at least 1  character(a-z A-Z) or 1 numeral]<span>')
         return false;
    }
    count =0
    a_friends=[]
    test=$("input[id^='group_member']")
    $("input[id^='group_member']").each(function(n){
    	if(this.checked==true){
          a_friends.push(this.name);
		}
	 });
    friend_list = a_friends.join("^^")
       $.post("../groups/new",{ friend_list : friend_list, group_name : group_name },
       function(data){
          notify(data)
       });
    return true
    }
    function validate_text_field(field_id){
      var pattern = /[a-zA-Z0-9]/
      var test = $("input[id='" + field_id + "']").val()
      if(pattern(test) != null){
			return test
      }
      return false
    } 
    function notify(msg){
        var notice = '<div class="notice">'
        + '<div class="notice-body">'
        + '<img src="../images/info.png" alt="" />'
        + '<h3>Alert!</h3>'
        + '<p>' + msg + '</p>'
        + '</div>'
        + '<div class="notice-bottom">'
        + '</div>'
        + '</div>';
        $( notice ).purr(
        {
            usingTransparentPNG: true
        }
        );
        return false;
     }

