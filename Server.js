



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

var https = require('https');
// require('https').globalAgent.options.ca = require('ssl-root-cas').create();
var fs = require('fs');
const { exit } = require('process');

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





let port1 = process.env.PORT || 3010;
const server1 = http.createServer(app);


server1.listen(4200, '0.0.0.0', function () {
//     console.log("in server",__dirname);

  console.log('Listening to port http:' + port1);
});
module.exports = app;
