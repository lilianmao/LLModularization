var callStackSQL = {
    insert:'INSERT INTO callStack(id, callChain, service, serviceType) VALUES(?,?,?,?)',
    batchInsert:'INSERT INTO callStack(id, callChain, service, serviceType) VALUES ?',
    queryAll:'SELECT * FROM callStack',
    getUserById:'SELECT * FROM callStack WHERE id = ? ',
    truncate:'truncate table callStack',
};

module.exports = callStackSQL;

// 注：
// 1. 批量插入是batchInsert，注意写法
