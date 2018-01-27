var express = require('express');
var app = new express();
var router = express.Router();
var querystring = require('querystring');

const UserDao = require('../dao/callStackDao');
const userDao = new UserDao();

/* GET users listing. */
// next是一个中间件请求
router.get('/', async function(req, res, next) {
    // ES6新语法：await和promise
    let result = await userDao.queryCount();
    res.send(result);
});

router.get('/getpage/', async function(req, res, next) {
    let pageNum = req.query['pagenum'];
    let pageSize = req.query['pagesize'];
    let pageContent = req.query['content'];
    let result = await userDao.queryByPage(pageNum, pageSize, pageContent);
    res.send(result);
});

router.get('/getcount/', async function(req, res, next) {
    let content = req.query['content'];
    let result = await userDao.queryCount(content);
    res.send(result);
});


/* POST users listing. */
router.post('/', async function(req, res, next) {
    userDao.truncate(req, res, next);

    var post = req.body;
    console.log(post);

    for (var key in post) {
        if (key == "callStacks[]") {
            callStack = post[key];
        }
    }

    var stacks = new Array();
    for (var item in callStack) {
        var callChain = splitCallChain(callStack[item]);
        stacks.push(callChain);
    }

    let result = await userDao.insert(stacks);
    console.log(result);
    res.send('respond with a resource');
});

function splitCallChain(callChain) {
    var array = new Array(6);
    var len = callChain.length;
    console.log(callChain);
    var chainPos = callChain.indexOf('callChain');
    var servicePos = callChain.indexOf('service');
    var serviceTypePos = callChain.indexOf('serviceType');
    var submitTypePos = callChain.indexOf('submitType');
    var datePos = callChain.indexOf('date');

    // TODO: 解析字符串，存在一些hard code。
    var id = callChain.substr(3, chainPos-5);
    var chain = callChain.substr(chainPos+10, servicePos-chainPos-12);
    var service = callChain.substr(servicePos+8, serviceTypePos-servicePos-10);
    var serviceType = callChain.substr(serviceTypePos+12, submitTypePos-serviceTypePos-14);
    var submitType = callChain.substr(submitTypePos+11, datePos-submitTypePos-13);
    var date = callChain.substr(datePos+5, len-datePos-4);

    array[0] = id;
    array[1] = chain;
    array[2] = service;
    array[3] = serviceType;
    array[4] = submitType;
    array[5] = date;

    return array;
}

module.exports = router;
