var user_id = $('#user_id').text();

var beating = false;
var beatBtn = $('#toggleBeating');
$(beatBtn).click(function(){
	beating = !beating;
	var t = beatBtn.text();
	beatBtn.text(t === "Trade!" ? "Stop!" : "Trade!")
	if ($(beatBtn).hasClass('btn-danger')){
		$(beatBtn).removeClass('btn-danger')
		$(beatBtn).addClass('btn-success')
	} else {
		$(beatBtn).removeClass('btn-success')
		$(beatBtn).addClass('btn-danger')
	}
	heartbeat();
})

$(document).ready(function (event){
	waitingForUser();
});

function waitingForUser(){
	if (user_id){
		beating = true
		return heartbeat()
	} 
	setTimeout(function(){
		waitingForUser()
	},100);
}

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
		$('#wallet_'+curr).text(wlt['balance'].toFixed( curr === 'usd' ? 2 : 4 ));
		$('#wallet_hold_'+curr).text('(in transaction: ' + wlt['on_hold'].toFixed( curr === 'usd' ? 2 : 4 ) + ')');
	}

	// trades
	$('.trades--scrollable tbody').empty();
	for (var key in data['trades']){
		var t = data['trades'][key];
		var created = moment(t['created_at']);
		var updated = moment(t['updated_at']);
     	var htmlParts = [
      				'<tr class="left__bar--trade_tr" id="trade_' + t['id'] + '">',
						'<td>' + created.format() + '</td>' ,
						'<td>' + t['status'] + '</td>',
						'<td>' + t['type'] + '</td>',
						'<td>' + t['amount'].toFixed(3) + '</td>' ,
						'<td>' + (t['price'] || 0).toFixed(3) + '</td>' ,
						'<td>' + updated.fromNow() + '</td>',
					'</tr>'
					]
      $('.trades--scrollable tbody').append(htmlParts.join('\n'))
	}

	// results
	var r = data['latest_eval'];
	var bc = Math.round(Math.log(r['buy_confidence']) * 5 + 100);
	if (bc < 0) bc = 0;
	var sc = Math.round(Math.log(r['sell_confidence']) * 5 + 100);
	if (sc < 0) sc = 0;
	$('#js-buy__decision').text(r['buy']==true?'Yes':'No');
	$('#js-buy__confidence').text(bc); 
	$('#js-sell__decision').text(r['sell']==true?'Yes':'No');
	$('#js-sell__confidence').text(sc); 
}

d3.select("body").transition().duration(5000)
      .style("background-color", '#666666');

// var data = [4, 8, 15, 16, 23, 42];

// var x = d3.scale.linear()
//     .domain([0, d3.max(data)])
//     .range([0, 420]);

// d3.select(".chart")
//   .selectAll("div")
//     .data(data)
//   .enter().append("div")
//     .style("width", function(d) { return x(d) + "px"; })
//     .text(function(d) { return d; });

