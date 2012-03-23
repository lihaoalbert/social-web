$(document).ready(function(){
	provinceselect();
	$("#province").change(function(){
		var chaprovince = $("#province").val();
		$("#city").empty();
		selcity(chaprovince,"")		
	});

	$("#txtselect").bind('keydown',function(e){
		if(e.keyCode==13){
			showLoading();
			var strselect = $("#txtselect").val();
			if(strselect != "")
			{
				userselect();
			}
			else
			{
				//alert("关键字不能为空")
				hideLoading();
			}
		}
	}); 

	$("#butselect").click(function()
	{
		showLoading();
		var strselect = $("#txtselect").val();
		if(strselect != "")
		{
			userselect();
		}
		else
		{
			//alert("关键字不能为空")
			hideLoading();
		}
	});
	
	function userselect()
	{
		var strselect = $("#txtselect").val();
		var strsintro = 0;
		var strsdomain = 0;
		var strgender = "n";
		var strprovince = $("#province").val();
		var strcity = $("#city").val();
		if($("#txtmes").attr('checked'))
		{
			strsintro = 1;
		}
		if($("#txtsdomain").attr('checked'))
		{
			strsdomain = 1;
		}
		if($("#man").attr('checked'))
		{
			strgender = "m";
		}
		if($("#woman").attr('checked'))
		{
			strgender = "f";
		}
		
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/weibo_users/user_display"
	    var strcode = 0
	    $.ajax({
	    	type: 'POST',
	    	url: strurl,
	    	data: {
	    		"strselect":strselect,
	    		"strsintro":strsintro, 
	    		"strsdomain":strsdomain, 
	    		"strgender":strgender, 
	    		"strprovince":strprovince, 
	    		"strcity":strcity
	    	},
	    	contentType: 'multipart/form-data',
	    	datatype: 'json',
	    	success:function(data)
	    	{
	    		$("#userselect").html(data);
	    		hideLoading();
                //alert(data);
	    	},
	    	error:function(xhr,r,e)
	    	{
	    		hideLoading();
	    		//alert(e);
	    	}
	    });
	}
	
	function provinceselect()
	{
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/weibo_users/selected_display";
	    var strcode = 0
	    $.ajax({
	    	type: 'POST',
	    	url: strurl,
	    	data: {"type":"province"},
	    	contentType: 'multipart/form-data',
	    	datatype: 'json',
	    	success:function(data)
	    	{
	    		var data = data.replace(/&quot;/g,"\"");
	    		//var data = data.replace(/&quot;,/g,"',")
	    		var dataObj=JSON.parse(data)
                //alert(dataObj.keyword);
                $("#province").prepend("<option value=''>省/直辖市</option>");
                for(p=0; p<dataObj.length; p++)
	            {
	            	$("#province").append("<option label='" + dataObj[p].Code + "' value='" + dataObj[p].Code + "'>" + dataObj[p].Name + "</option>")
	            };
                strcode=$("#province").val(); 
                if(selcity(strcode,""))
                {
                	
                }              
	    	},
	    	error:function(xhr,r,e)
	    	{
	    		alert(e)
	    	}
	    });
	}
	
	function selcity(strcode,citycode)
	{
		$("#city").empty();
		var strhost = window.location.host;
	    var strprotocol = window.location.protocol;
	    var strurl = strprotocol + "//" + strhost + "/weibo_users/selected_display";
		$.ajax({
	    	type: 'POST',
	    	url: strurl,
	    	data: {"type":"city","code":strcode},
	    	contentType: 'multipart/form-data',
	    	datatype: 'json',
	    	success:function(data)
	    	{
	    		var data = data.replace(/&quot;/g,"\"");
	    		//var data = data.replace(/&quot;,/g,"',")
	    		var dataObj=JSON.parse(data)
                //alert(dataObj.keyword);
                
                for(p=0; p<dataObj.length; p++)
	            {
	            	$("#city").append("<option label='" + dataObj[p].Code + "' value='" + dataObj[p].Code + "'>" + dataObj[p].Name + "</option>")
	            };
	            $("#city").val(citycode);
	            //$("#city").val("");
	    	},
	    	error:function(xhr,r,e)
	    	{
	    		alert(e);
	    	}
	    });
	    
	    return true;
	}
});