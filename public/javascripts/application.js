// Common JavaScript code across your application goes here.
  $(document).ready(function(){
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
/*
   $("#dialog_twitter_config").dialog({
       autoOpen: false,
       buttons: {
       "Save": function(){
        $(this).dialog("close")
       },
       "Cancel": function(){
        $(this).dialog("close")
       }  
		 }
   });

   $("#dialog_search_config").dialog({
       autoOpen: false,
       buttons: {
       "Save": function(){
        $(this).dialog("close")
       },
       "Cancel": function(){
        $(this).dialog("close")
       }  
		 }
   });
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
  });
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

