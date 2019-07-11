
var position = [33,48,62];
var index = 0;
var lives=3;

window.onload =function(){
	var audio1=new Audio("static/car.mp3");
	audio1.play();
	main();
	setInterval(doWork,100);
	
};

// function animate_up()
// {
//   alert("up");

// }
$(document).ready(function(){
  $(".right").click(function(){
  	 if(index == 2)
  	 {
  	 	return;
  	 }
  	 else
  	 {
  	 	index++;
  	 }
  	 var new_left= position[index] + '%';
     $("#controller").animate({'left': new_left});
    //alert("hello");
  }); 
});

// $(document).ready(function(){
// 	setInterval(function(){
// 		var status = $('.coin-count').css('top');
//   		if (status == '800px')
//   			console.log("here we areee");

//         }, 1);
  	

// });



$(document).ready(function(){
  $(".left").click(function(){
  	if(index == 0)
  	{
  		return;
  	}
  	else
  	{
  		index--;
  	}	
  	var new_left = position[index] + '%';
    $("#controller").animate({'left': new_left});
    //alert("hello");
  }); 
});


function showDialog() {
//	$("#dialog").css("display: block");
//	$("#dialog").dialog({ title: "Oh No`!" }, {close: function( event, ui ) { window.location.reload(true);}})
}


var checked=false;
$(document).ready(function(){
        var x = 0;
        setInterval(function(){
			$('body').css('background-position',"0px "+ ++x + 'px');
			var wh=$(window).height()-150;
			var ch=parseInt($(".coin1").css("top").replace("px",""));
			if (!checked && wh <= ch)
			{
				check_answer();
				checked=true;
			}
			if (ch<wh)
				checked=false;

        }, 10);

});

/*
$(document).ready(function(){
        setInterval(function(){
        	//console.log("CHECK CHECK CHECKKK");
			

        }, 6000);


});
*/

var data = 
        { 
            "a":0,
          "hs":false 
		};
		
function doWork() {

	// ajax the JSON to the server
	$.getJSON("receiver",data, function(data2) {
		
		var a=data2["a"]
		var b=data2["hs"]
		//console.log(a+"  "+b);
		
		
		a-=10;
		deg=a*1.6;
		$("#toggle").css({'transform' : 'rotate('+ deg +'deg)'});
		$("#controller").css({'transform' : 'rotate('+ deg +'deg)'});
		//console.log("a: "+a);

		var ww=$(window).width();
		var lb=ww*0.3;
		var rb=ww*0.64;
		var cl=parseInt($("#controller").css("left").replace("px",""));
		console.log("cl: "+cl+" lb: "+lb+" rb: "+rb);
		if(cl<=lb-10)
			$("#controller").css({"left":"+="+15});
		else if(cl>=rb+10)
			$("#controller").css({"left":"-="+15});
		else	
		{
			$("#controller").css({"left":"+="+a});
			if (a>10)
			{

			}
		}
	});
}






function show_coins() {
	console.log($(document).width());
    var width = "+=" + $(document).width();
    $(".coin1").animate({
    top: width,
  }, 6000,'linear', function() {
	    $(".coin1").css('top','0px');
  });
}

var isFinished=true;
var num1 = 0;
var num2 = 0;
var coin = [0,0,0];
var index_actual = 0;
 
function main(){

	setInterval(function(){
		reset_coins();
		display_equation(num1, num2);
		display_coins(coin);
		show_coins();
		//var temp = index_actual;
		//check_answer();
		
    }, 6000);

}

function reset_coins(){
	num1 = get_rand_num(); 
	num2 = get_rand_num();
	coin = coins(num1,num2);
	//display_equation(num1,num2);

}



function coins(num1, num2){

	var coin = [0,0,0]; // init coins array
	var sum = num1 + num2; 
	index_actual = Math.floor(Math.random()*3);
	coin[index_actual] = sum; //put in answer randomly
	// fill in random values between 1-20
	var set = new Set();
	set.add(sum);
	for(var i = 0; i<3; i++)
	{
		if(coin[i]!=0)
		{
			continue;
		}

		var val = Math.floor(Math.random()*20) + 1;
		while(set.has(val))
		{
			val = Math.floor(Math.random()*20) + 1;
		}

		coin[i] = val;
		set.add(val);
		
	}
	return coin;
}

function get_rand_num()
{
	return Math.floor(Math.random() * 10) + 1;
}


function display_coins(text)
{
	var src = $('.coin1');
	src.html('');
	var img = $('<img/>', { id: "c1", src : "static/pics/" + text[0] + ".png" }).appendTo(src);
	var img2 = $('<img/>', { id: "c3", src : "static/pics/" + text[1] + ".png" }).appendTo(src);
	var img3 = $('<img/>', { id: "c5", src : "static/pics/" + text[2] + ".png" }).appendTo(src);

}

function display_equation(num1, num2)
{
	document.getElementById("math").innerHTML = (num1 + " + " + num2 + " = ");
}

function wait(ms){
   var start = new Date().getTime();
   var end = start;
   while(end < start + ms) {
     end = new Date().getTime();
  }
}

function check_answer(){
	var width = $('.coin1').css('width');
	console.log(width);
	var coin_position = $('#controller').css('left');
	var num = parseFloat(coin_position)/parseFloat(width) * 100;
	console.log(Math.ceil(num));


	console.log("answer is in " + index_actual);


	
	var percent=position[index_actual];
	var lower=percent-3;
	var higher=percent+3;
	console.log("index_actual: " + index_actual);
	var ans=Math.ceil(num);

	if (ans <= higher && ans >=lower){
		console.log("hit");
		var child=$('.coin1').children().eq(index_actual)
		child.css({position:"absolute"});
		child.animate({left:"-=1000"});
		inc_coin();
	} else {
		if (lives>0){
			lives--;
			$("#lives").children().eq(0).remove();
			if (lives==0)
				showDialog();
		} 
	}


}

function inc_coin(){
var recent = $('#count').text();
var num = parseInt(recent);
num++;
$('#count').text(num);
$('#count').animate({fontSize :"+=50"},'fast');
$('#count').animate({fontSize :"-=50"},'fast');

}









