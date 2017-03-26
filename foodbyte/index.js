var unirest = require("unirest");
var prompt = require("prompt-sync")();
var ConversationV1 = require("watson-developer-cloud/conversation/v1");
var express    = require('express');
var app        = express();    
var bodyParser = require('body-parser');


var conversation = new ConversationV1 ({
	username: "d8543abd-4c79-43bb-9bc0-5f48a88a75cf",
	password: "sReyg2eYisvp",
	path: { workspace_id: "4d835574-257e-4a41-b1f9-4b97669b495f" },
	version_date: "2017-03-25"
})

// get code from front end
function IDToRecipe(ID, callback) {
	unirest.get("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + ID + "/analyzedInstructions?stepBreakdown=true")
	.header("X-Mashape-Key", "7NFUuGWrn4msh6xdTxS0rv6FpdH6p14BsRyjsng0MeEmS0c6L2")
	.header("Accept", "application/json")
	.end(function (result) {
	    return callback(result.body[0].steps);
	});
}

function similarRecipe(ID, callback) {
	unirest.get("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + ID + "/similar")
.header("X-Mashape-Key", "7NFUuGWrn4msh6xdTxS0rv6FpdH6p14BsRyjsng0MeEmS0c6L2")
.header("Accept", "application/json")
.end(function (result) {
	return callback([result.status, result.headers, result.body]);
});
}

// similarRecipe(207, function(result) {
// 	console.log(result[2])
// })


function getID (query, callback) {
	unirest.get("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?instructionsRequired=true&limitLicense=false&number=10&offset=0&query=" + query)
			.header("X-Mashape-Key", "7NFUuGWrn4msh6xdTxS0rv6FpdH6p14BsRyjsng0MeEmS0c6L2")
			.header("Accept", "application/json")
			.end(function (result) {
			  	//console.log(result.status, result.headers, result.body);
			  	return([result.status, result.headers, result.body]);
			});
}


var newgetIntentFromUser = "chinese food";
var requested = 0;

function getIntent(input, callback) {
	console.log(input + " is the input");
	conversation.message({
		input: { text: input },
	}, function (err, response) {
		console.log(response);
		if (err) return err;

		var intent = "";
		if (response.intents.length > 0) 
			intent = response.intents[0].intent;
		return intent;
	})
}

//configure rest api

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 8080;        // set our port

var router = express.Router();              // get an instance of the express Router

app.listen(port);
console.log('Magic happens on port ' + port);

router.get('/', function(req, res) {
    res.json({ getIntent: 'hooray! welcome to our api!' });   
});

app.use('/api', router);


router.use(function(req, res, next) {
    // do logging
    console.log('Something is happening.');
    next(); // make sure we go to the next routes and don't stop here
});


router.route('/recipes/:recipe_string')
	.get(function(req, res) {
		conversation.message({
		input: { text: req.params.recipe_string },
		}, function (err, response) {
			console.log(response);
			if (err) res.send(err);

			var intent = "";
			if (response.intents.length > 0) 
				intent = response.intents[0].intent;
			console.log("intent", intent);
			res.json(intent);
		})        
    });
    

 router.route('/recipe/:recipe_id')
	.get(function(req, res) {
		getID(req.params.recipe_id, function(err, query) {
			if(err) res.send(err);

			res.json(query);
		})
        
        
    });
