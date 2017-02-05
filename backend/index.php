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
    'option' => [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    ],
]);

$app = new \Slim\App;

$app->get('/hello/{name}', function (Request $request, Response $response) {
    $name = $request->getAttribute('name');
    $response->getBody()->write("Hello, $name");

    return $response;
});

$app->get('/getBooks', function (Request $request, Response $response) {
    global $database;
    $books = $database->select("bookstatus", '*');
    $booksArr = [];

    foreach ($books as $book){
        $bookObj =array(
            "bookId" => intval($book["bookId"]),
            "published" => $book["published"],
            "author"=> $book["author"],
            "title"=> $book["title"]
        );
        if($book['borrowedBy'] != NULL)$bookObj["borrowedBy"] = intval($book["borrowedBy"]);
        array_push($booksArr, $bookObj);
    }

    $response->getBody()->write(json_encode($booksArr));
    return $response;
});

$app->post('/login', function(Request $request, Response $response){
    global $database;
    $credentials = $request->getParams();

    $userRecord = $database->select("user", "*", [
        "AND" => [
            "username[=]" => $credentials["username"],
            "password[=]" => sha1($credentials["password"])
        ]
    ]);

    $response->getBody()->write(json_encode($userRecord));

    return empty($userRecord) ? $response->withStatus(403) : $response->withStatus(200);
});

$app->post('/borrowBook', function(Request $request, Response $response){
    global $database;

    $bookId = intval($request->getParams()["bookId"]);
    $userId = intval($request->getParams()["userId"]);

    try {
        $newLoanId = $database->insert("loan", [
            "bookId" => $bookId,
            "userId"=> $userId
        ]);

    } catch (Exception $e) {
        return $response->getBody()->write($e->getMessage());
    }

    return $response->getBody()->write("Book borrowed loanId is ".$newLoanId." ".json_encode($database->error()));
});

$app->post('/returnBook', function(Request $request, Response $response){
    global $database;

    $bookId = $request->getParams()["bookId"];
    $userId = $request->getParams()["userId"];

    $latestLoanDate = $database->max("loan", "date", [
            "bookId[=]" => $bookId,
    ]);

    $loanRec = $database->select("loan", "*", [
        "AND" => [
            "bookId[=]"=>$bookId,
            "date[=]"=>$latestLoanDate
        ]
    ]);

    try {
        $newReturnId = $database->insert("bookreturn", [
            "bookId" => $bookId,
            "userId"=> $userId,
            "loanId" => $loanRec[0]["loanId"]
        ]);

    } catch (Exception $e) {
        return $response->getBody()->write($e->getMessage()." ".json_encode($request->getParams()));
    }

    return $response->getBody()->write("Book Returned ".$newReturnId." ".json_encode($database->error()));
});

$app->get('/getBook/{bookId}', function(Request $request, Response $response){
    global $database;
    $bookId = $request->getAttribute('bookId');

    $book = $database->select("book", "*", [
        "AND" => [
            "bookId[=]" => $bookId
        ]
    ]);

    return $response->getBody()->write(json_encode($book));
});

$app->run();