// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var beating = false;
$(document).ready(function (event){
	beating = true
	heartbeat();
});

function heartbeat(){
	keepAlive()
	setTimeout(function(){
		heartbeat();
	},6000);
}

function keepAlive(){
	console.log("i'm alive!!!")
	$.post('users/1/decisions')
}



