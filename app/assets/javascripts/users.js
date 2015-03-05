var user_id = $('#user_id').text();

var beating = false;
var beatBtn = $('#toggleBeating');
$(beatBtn).click(function(){
	beating = !beating;
	var t = beatBtn.text();
	beatBtn.text(t === "Start" ? "Stop" : "Start")
	heartbeat();
})

// $(document).ready(function (event){
// 	beating = true
// 	heartbeat();
// });

function heartbeat(){
	if (beating){
		keepAlive()
		setTimeout(function(){
			heartbeat();
		},6000);
	}
}

function keepAlive(){
	console.log("i'm alive!!!")
	makeDecision()
	setTimeout(function (){
		checkOpenTrades();
	},3000);
}

function makeDecision(){
	var request = $.post('/users/' + user_id + '/decisions')
	request.done(function(data){
//    	console.log(data);
		updateDash(data);
	});
	request.fail(function(data){
    	alert('Error making decision');
    	console.log(data);
	});
}

function checkOpenTrades(){
	var request = $.post('/users/' + user_id + '/pending_trades')
	request.done(function(data){
    	updateDash(data);
	});
	request.fail(function(data){
    	alert('Error checking open trades');
    	console.log(data);
	});
}

function updateDash(data){
	console.log("data: ", data);
	// wallets
	for (var key in data['wallets']){
		var wlt = data['wallets'][key];
		var curr = wlt['currency'];
		$('#wallet_'+curr).text(wlt['balance']);
	}

	// trades
	$('.left__bar--scrollable').empty();
	for (var key in data['trades']){
		var t = data['trades'][key];
     	var htmlParts = [
      				'<tr class="left__bar--trade_tr" id="trade_' + t['id'] + '">',
						'<td class="left__bar--trade-type">' + t['type'] + '</td>',
						'<td class="left__bar--amount">', 
							t['amount'].toFixed(3) ,
							'at',
							(t['price'] || 0).toFixed(3) ,
						'</td>',
						'<td>',
							((Math.floor(Date.now()/1000) - t['updated_at']) / 60).toString() + 'm ago',
						'</td>',
					'</tr>'
					]
      $('.left__bar--scrollable').append(htmlParts.join('\n'))
	}

	// results
	var r = data['latest_eval'];
	$('#js-buy__decision').text(r['buy']);
	$('#js-buy__confidence').text(r['buy_confidence'].toFixed(3));
	$('#js-sell__decision').text(r['sell']);
	$('#js-sell__confidence').text(r['sell_confidence'].toFixed(3));
}


// d3.select("body").transition(3000)
//     .style("background-color", '#dddddd');

var data = [4, 8, 15, 16, 23, 42];

var x = d3.scale.linear()
    .domain([0, d3.max(data)])
    .range([0, 420]);

var div = $('#playField');
div.innerHtml = "Hello, world!";

d3.select(".chart")
  .selectAll("div")
    .data(data)
  .enter().append("div")
    .style("width", function(d) { return x(d) + "px"; })
    .text(function(d) { return d; });

