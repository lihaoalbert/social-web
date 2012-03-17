$(document).ready(function(){  
	$('input:text:first').focus();
	var datecustom = $(":radio:checked").val();
	if(datecustom == "user")
	{
		$("#startdate").attr("disabled",false);
		$("#enddate").attr("disabled",false);
	}
	else
	{
		$("#startdate").attr("disabled",true);
		$("#enddate").attr("disabled",true);
	}
	$(":radio").click(function(){        
        var datecustom = $(":radio:checked").val();
	    if(datecustom == "user")
	    {
	    	$("#startdate").attr("disabled",false);
	    	$("#enddate").attr("disabled",false);
	    }
	    else
	    {
	    	$("#startdate").attr("disabled",true);
	    	$("#enddate").attr("disabled",true);
	    	var nowdate = new Date();
	    	var nowyear = nowdate.getFullYear();
	    	var nowmonth = parseInt(nowdate.getMonth(),10)+1;
	    	nowmonth = todate(nowmonth);
	    	var nowday = nowdate.getDate();
	    	nowday = todate(nowday);
	    	var weekdate = new Date(new Date().getTime() - 7*24*60*60*1000);
	    	var weekyear = weekdate.getFullYear();
	    	var weekmonth = parseInt(weekdate.getMonth(),10)+1;
	    	weekmonth = todate(weekmonth);
	    	var weekday = parseInt(weekdate.getDate(),10) + 1;
	    	weekday = todate(weekday);
	    	var monthdate = new Date(new Date().getTime() - 30*24*60*60*1000);
	    	var monthyear = monthdate.getFullYear();
	    	var monthmonth = parseInt(monthdate.getMonth(),10)+1;
	    	monthmonth = todate(monthmonth);
	    	var monthday = parseInt(monthdate.getDate(),10) + 1;
	    	monthday = todate(monthday);
	    	
	    	if(datecustom == "week")
	    	{
	    		$("#startdate").val(weekyear + "-" + weekmonth + "-" + weekday);
	    		$("#enddate").val(nowyear + "-" + nowmonth + "-" + nowday);
	    	}
	    	if(datecustom == "month")
	    	{
	    		$("#startdate").val(monthyear + "-" + monthmonth + "-" + monthday);
	    		$("#enddate").val(txtyear + "-" + txtmonth + "-" + txtday);
	    	}
	    }
   });
   $("#startdate").blur(function(){
		var datetxt = $("#startdate").val();
		var reg = /^(\d{4})\-(\d{2})\-(\d{2})$/;
		var result = reg.exec(datetxt);
		if(result == null)
		{
			$("#startdatetxt").html("日期格式不符(yyyy-mm-dd)");
		}
		else
		{
			$("#startdatetxt").html("");
		}
	});
	$("#enddate").blur(function(){
		var datetxt = $("#enddate").val();
		var reg = /^(\d{4})\-(\d{2})\-(\d{2})$/;
		var result = reg.exec(datetxt);
		if(result == null)
		{
			$("#enddatetxt").html("日期格式不符(yyyy-mm-dd)");
		}
		else
		{
			$("#enddatetxt").html("");
		}
	});
   function todate(strdate)
   {
   	strdate = "0" + strdate;
   	strdate = strdate.substring(strdate.length-2);
   	return strdate
   }
});