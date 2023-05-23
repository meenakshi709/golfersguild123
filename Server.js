



const express = require('express');
const app = express();
var path = require('path');
const dataApi = require('./restapi/dataApi');
const routes = require('./restapi/routes/route.js');
var http = require('http');



const router = express.Router();
var cookieParser = require('cookie-parser');
// const helmet = require('helmet');
// app.use(helmet());
var cors = require('cors');
const fileUpload = require('express-fileupload');



// app.use(express.static(path.join(__dirname, 'public')));
app.use(cors());
// app.engine('html', require('ejs').renderFile);
var mcache = require('memory-cache');


var cache = (duration) => {
  return (req, res, next) => {
    let key = '__express__' + req.originalUrl || req.url
    let cachedBody = mcache.get(key)
    if (cachedBody) {
      res.send(cachedBody)
      return
    } else {
      res.sendResponse = res.send
      res.send = (body) => {
        mcache.put(key, body, duration * 1000);
        res.sendResponse(body)
      }
      next()
    }
  }
}
var debug = require('debug')('app');
var name = 'golfersguild';
debug('booting %s', name);



// require('https').globalAgent.options.ca = require('ssl-root-cas').create();
var fs = require('fs');
const { exit } = require('process');
app.use(fileUpload());
app.use(cookieParser({ SameSite: true }));
app.use(express.json({ limit: "6mb" }));
app.use(express.urlencoded({ extended: true }));
app.set('view engine', 'ejs');
// app.use(express.static(path.join(__dirname, 'nodeproject')));
app.use('/dataApi', dataApi, cache(10));
app.use('/', routes);

app.use(express.static(path.join(__dirname, './dist/golfersguild/')));
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, './dist/golfersguild/index.html'));
});



// const server = http.createServer(app);

let port1 = process.env.PORT || 3010;
const server1 = http.createServer(app);

const io = require('socket.io')(server1);
// Socket connections

const socketCtrl=require('./restapi/socketController');


  io.on('connection', function(socket){
        console.log("A user connected",socket.id)
        socketCtrl.socketConnection(socket,io);

       
        socket.on('disconnect',function() {   
      
        socketCtrl.disconnectdevice(socket.id);
        console.log('A user disconnected');
        });
      });



server1.listen(4200, '0.0.0.0', function () {
//     console.log("in server",__dirname);

  console.log('Listening to port http:' + port1);
});

module.exports = app;
