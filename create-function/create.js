var AWS = require('aws-sdk');
var ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

exports.handler = async (event) => {
    try {
	    var obj = JSON.parse(event.body);
	    var itemId = obj.id;
	    var itemName = obj.name;
	    var params = {
		    TableName:'Items',
		    Item: {
			    id : {S: itemId},
			    name : {S: itemName}
		    }
	    };
	    var data;
	    var msg;
	    try{
		    data = await ddb.putItem(params).promise();
		    console.log("Item created successfully:", data);
		    msg = 'Item created successfully';
	    } catch(err){
		    console.log("Error: ", err);
		    msg = err;
	    }
	    var response = {
		    'statusCode': 200,
		    'body': JSON.stringify({
			    message: msg
		    })
	    };
    } catch (err) {
	    console.log(err);
	    return err;
    }
	
    return response;
};
