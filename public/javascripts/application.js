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
// function for tweeting
   $("#dialog_send_tweet").dialog({
       width: 500,
       autoOpen: false,
       buttons: {
       "Send": function(){
        res=send_tweet(this)
        if(res == true){
	   $(this).dialog("close")
        }
       },
       "Cancel": function(){
        $(this).dialog("close")
       }  
	 }
   });
   $("a[id^='dialog_link_tweet']").click(function(){
       var twit_id=this.id.split(/\_/).pop()
       $("#send_tweet_twit_id").val(twit_id)
	 $('#dialog_send_tweet').dialog('open');
	 return false;
	});

/*
   $("a[id^='twitter_dialog']").livequery(function(){
      $(this).click(function(){
		$('#dialog_twitter_config').dialog('open');
		return false;
	});
   });
*/
//---------function for saving preferences---------------
$("#save_group").click(function(){
  var rm_visual_notify=false
  if($('#visual_notify').attr('checked') == true){
     rm_visual_notify=true
  }
  var rm_audio_notify=false
  if($('#audio_notify').attr('checked') == true){
    rm_audio_notify=true
  }
  var rm_tweet_query_pct=isNumeric($('#tweet_query_pct').val())
  if(rm_tweet_query_pct == false || rm_tweet_query_pct > 100 || rm_tweet_query_pct < 0){
      notify("<div style='color: red'>Percent Allocated to tweet queries must be a number greater than 0  and less than 100</div>")
	return false
  }
  var rm_tweets_displayed=isNumeric($('#tweets_displayed').val())
  if(rm_tweets_displayed == false ||  rm_tweets_displayed < 0){
      notify("<div style='color: red'>Tweets displayed must be a number greater than 0<div>")
      return false
  }
  $.post("../users/update",{ visual_notify : rm_visual_notify, audio_notify : rm_audio_notify, tweet_query_pct : rm_tweet_query_pct, tweets_displayed : rm_tweets_displayed },
  function(data){
    notify(data)
  })
})

//---------Function for updating tweets every minute-------------------
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
//-----Functionn for character counting of tweet-----
   $("#tweet_text").keyup(function(){
     var rem_chars = 140 - $(this).val().length;
     $("#tweet_counter").html(rem_chars + ' characters left')
   })
   

   $("#tabs").tabs();
   $(function(){ 
      $(".haccordion").haccordion(); 
   }); 
  })
//--------------------------End of document ready function------------------------------
 function send_tweet(caller){
       var twit_id = $("#send_tweet_twit_id").val()
       var msg = $("#tweet_text").val()
        $.post("../twits/send_tweet",{ twit_id : twit_id, msg : msg },function(data){
         notify(data);
        });
        $("#tweet_text").val("");
        $("#send_tweet_twit_id").val("");
        $("#tweet_counter").html('140 characters left');
        return true
 }
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
    function isNumeric(val){
      if(isNaN(parseInt(val))){
	return false
      }
      else{
	return parseInt(val)
      }
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
// SeViR Simple Horizontal Accordion @2007
// http://letmehaveblog.blogspot.com
jQuery.fn.extend({
  haccordion: function(params){
    var jQ = jQuery;
    var params = jQ.extend({
      speed: 500,
      headerclass: "header",
      contentclass: "content",
      contentwidth: 350
    },params);
    return this.each(function(){
      jQ("."+params.headerclass,this).click(function(){
        var p = jQ(this).parent()[0];
        if (p.opened != "undefined"){
          jQ(p.opened).next("div."+params.contentclass).animate({
            width: "0px"
          },params.speed);
        }
        p.opened = this;
        jQ(this).next("div."+params.contentclass).animate({
          width: params.contentwidth + "px"
        }, params.speed);
      });
    });
  }
});
