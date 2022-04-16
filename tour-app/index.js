var express = require('express');
var app = express();
app.use(express.static('src'));
app.use('/src', express.static('../tour-app/node_modules/'));
app.use(express.static('../tour-contract/build/contracts'));
const bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.post('/savetoFile', function(req,res){
  console.log("Entered Into Request" );
  file=JSON.parse(req.body.data);
  console.log(file);
  const fs = require('fs');
  fs.writeFile("./src/tourAttr.json",JSON.stringify(file,null,2),function(err){
    if (err) return console.log(err);
  });
});



app.get('/', function (req, res) {
  res.render('index.html');
});
app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});