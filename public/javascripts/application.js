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
       $("#group_twit_id").val(twit_id)
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
   $("#user_display").everyTime(60000,function(i){
      $("div[id^=group_bar]").each(function(n){
          var twit_id=this.id.split(/_/)[2]
          $.post("../twits/get_status",{ twit_id : twit_id }, function(data){
             span_id="#remain_" + twit_id
             a_res=eval(data)
             $(span_id).text(a_res[0])
             if(a_res[1]){
		get_group_tweets(twit_id)
             }
             if(a_res[2]){
		get_search_tweets()
	     } 
          });
      });
   });

   $("#tabs").tabs();
  })
//--------------------------End of document ready function------------------------------
  function get_search_tweets(){
     var test_length=$("div[id^=search_]").length - 1
     $("div[id^=search_]").each(function(n){
 	var search_id = this.id.spplit(/_/)[1]
        if(n == test_length){
          var vars={ search_id : search_id, reset : 1 }
        }
        else{
	  var vars={ search_id : search_id}
        }
        $.post("../searches/get_new_searches",vars,function(data){
           tableID="#table_search_" + search_id + " tbody"
           $(tableID).html(data) 
        });
     });
  }
  function get_group_tweets(twit_id){
      var test="div[id^=group_" + twit_id + "]"
      var test_length=$(test).length - 1
      $(test).each(function(n){
         var group_name=this.id.split(/_/)[2]

         if(n==test_length){
		var vars={group_name : group_name, twit_id : twit_id, reset : 1 }
         }
         else{
    		var vars={ group_name : group_name, twit_id : twit_id }
         }
         $.post("../groups/get_group_tweets", vars, function(data){
           tableID="#table_" + twit_id + "_" + group_name + " tbody"
           $(tableID).html(data)  
	});
      });
  }

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
    twit_id=$("#group_twit_id").val()
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
       $.post("../groups/new",{ friend_list : friend_list, group_name : group_name, twit_id : twit_id },
       function(data){
          reset_group_dialog()
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
    function reset_group_dialog(){
	$("#group_name").val('')
        $("#groupp_twit_id").val('')
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

