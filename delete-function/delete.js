var AWS = require('aws-sdk');
var ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

exports.handler = async (event) => {
  try {
    var obj = JSON.parse(event.body);
    
    var itemId = obj.id;
    var params = {
      TableName:'Items',
      Key: {
        id : {S: itemId}
      }
    };
    
    var data;
    
    try{
      data = await ddb.deleteItem(params).promise();
      console.log("Item deleted successfully:", data);
    } catch(err){
      console.log("Error: ", err);
      data = err;
    }
    
    var response = {
      'statusCode': 200,
      'body': JSON.stringify({
        message: data
      })
    };
  } catch (err) {
    console.log(err);
    return err;
  }
  return response;
};
