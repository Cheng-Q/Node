const express = require('express')
const fs = require('fs')
const bodyParser = require('body-parser')
// 爬取列表数据
const https = require('https')
const cheerio = require('cheerio')
const path = require('path')
const app = express()
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: false}))
app.all('*', (req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*'); //访问控制允许来源：所有
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'); //访问控制允许报头 X-Requested-With: xhr请求
  res.header('Access-Control-Allow-Metheds', 'PUT, POST, GET, DELETE, OPTIONS'); //访问控制允许方法
  res.header('X-Powered-By', 'nodejs'); //自定义头信息，表示服务端用nodejs
  res.header('Content-Type', 'application/json;charset=utf-8');
  next();
})
app.all('/pa',(req,res) => {
  console.log('11',req.body)
  res.write('正在抓')
  let url = 'https://www.csdn.net/?spm=1000.2115.3001.4476'
  let nameClass = '.nav_center_wrap li'
  console.log('1111111')
  fn(url,nameClass,res)
  

})
app.get('/api', (req, res) => {
  console.log(path.join(__dirname,'../../www/server/tarbar.json'))
  let file = path.join(__dirname,'tarbar.json')
  fs.readFile(file, 'utf-8', (err,data) => {
    if(err) {
      res.send('读取文件失败')
    } else {
      res.send(data)
    }
  })
})



const fn = function(url,item,callback){ 
  let aa = ''
  https.get(url,res => {
    let data = ""
    res.on('data', chunk => {
      data += chunk
    })
    res.on('end', () => {
      filterHtml(data,item,callback)
    })
  }).on('error', rq => {
    console.log(rq)
  })

  function filterHtml(html,nameClass,callback) {
    let $ = cheerio.load(html)
    let options = $(nameClass)
    let data = []
    options.each((i,item) => {
      let text = $(item).children().text()
      let href = $(item).children().attr('href')
      let target = $(item).children().attr('target')
      let reportClick = $(item).children().attr('data-report-click')
      let reportQuery = $(item).children().attr('data-report-query')
      console.log(href)
      data.push({
        text,
        href,
        target,
        reportClick,
        reportQuery
      })
    })
    data = JSON.stringify(data)
    fs.writeFile('../www/server/tarbar.json',data, 'utf-8',(error) => {
      //监听错误，如正常输出，则打印null
      if(error==null){
       callback.write('写入成功')
       callback.end();
       console.log('写入成功')
      }
    })
  }
  
}

let port = 8088 // 端口
let host = '127.0.0.1'
app.listen(port, host, (res) => {
   console.log(`服务器运行在http://${host}:${port}`);
})