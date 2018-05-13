const port = process.env.PORT || 3000;
const http = require('http');
const fs = require('fs');
const path = require('path');

http.createServer(function (request, response) {
    let filePath = './public' + request.url;
    if (filePath == './public/')
        filePath = './public/index.html';

    const extname = path.extname(filePath);
    let contentType;
    switch (extname) {
        case '.js':
            contentType = 'text/javascript';
            break;
        case '.css':
            contentType = 'text/css';
            break;
        case '.json':
            contentType = 'application/json';
            break;
        case '.png':
            contentType = 'image/png';
            break;      
        case '.jpg':
            contentType = 'image/jpg';
            break;    
        case '.gif':
            contentType = 'image/gif';
            break;
        case '.mp4':
            contentType = 'video/mp4';
            break;
        default:
            contentType = 'text/html';
    }

    fs.readFile(filePath, function(error, content) {
        if (error) {
            if(error.code == 'ENOENT'){
                response.writeHead(404);
                response.end(`404 - That thing doesn't exist`);
                response.end(); 
            }
            else {
                console.error(error);
                response.writeHead(500);
                response.end(`Woah, something went wrong! Error Code: ${error.code}`);
                response.end(); 
            }
        }
        else {
            response.writeHead(200, { 'Content-Type': contentType });
            response.end(content, 'utf-8');
        }
    });
})
.listen(port);
console.log('listening on port', port);