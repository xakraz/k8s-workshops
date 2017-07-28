const fs = require('fs');

var config;

config = {
  production: {
    url: 'http://127.0.0.1:NODEPORT',
    database: {
      client: 'mysql',
      connection: {
        host: 'mysql.NAMESPACE.svc.cluster.local',
        user: 'ghost',
        password: 'myp4ss',
        database: 'ghost',
        charset: 'utf8',
      }
    },
    server: {
      host: '127.0.0.1',
      port: '2368'
    },
    paths: {
      contentPath: '/var/lib/ghost'
    },
  }
}

module.exports = config;
