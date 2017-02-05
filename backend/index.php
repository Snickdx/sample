<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require 'vendor/autoload.php';

$database = new medoo([
    // required
    'database_type' => 'mysql',
    'database_name' => 'sampledb',
    'server' => 'localhost',
    'username' => 'sample',
    'password' => 'sample',
    'charset' => 'utf8',
]);


$app = new \Slim\App;

$app->get('/hello/{name}', function (Request $request, Response $response) {
    $name = $request->getAttribute('name');
    $response->getBody()->write("Hello, $name");

    return $response;
});

$app->get('/getBooks', function (Request $request, Response $response) {
    global $database;
    $books = $database->select("books", '*');

    $response->getBody()->write(json_encode($books));
    return $response;
});

$app->run();