var app = angular.module('sample', ['ui.bootstrap']);

var url = "http://localhost";

console.log('loaded app');

app.controller('mainController', function($scope, AuthService, BackendService){

    $scope.input = {
        username: "",
        password: "",
        returnedBook: "Select Option"
    };

    $scope.userId = 1;

    $scope.books = [
        {
            author:"bob",
            published: "yesterday",
            title:"kek"
        },
        {
            author:"bob",
            published: "today",
            title:"kek2",
            borrowedBy: 3
        },
        {
            author:"janis",
            published: "sometime",
            title:"kek3",
            borrowedBy: 1
        },
        {
            author:"janis",
            published: "sometime",
            title:"kek4",
            borrowedBy: 1
        }
    ];

    $scope.loggedIn = true;

    $scope.loadBooks = function(){
        BackendService.getBooks(function(response){
            $scope.books = response.data;
        });
    };

    $scope.login = function(){
        AuthService.login($scope.input, function(response){
            if(response.response == 200){
                alert("logged In");
                $scope.loggedIn = true;
                $scope.userId = response.data.id;
            }else{
                alert("error");
            }
        });
    };

    $scope.logout = function(){
        $scope.loggedIn = false;
    };

    $scope.borrowBook = function(id){
        BackendService.borrowBook(id, function(response){
            if(response.status == 200){
                alert("success");
            }else{
                alert("error");
            }
            $scope.loadBooks();
        });
    };

    $scope.returnBook = function(){
        BackendService.returnBook($scope.input.returnedBook, function(response){
            if(response.status == 200){
                alert("success");
            }else{
                alert("error");
            }
            $scope.input.returnedBook = "Select Option";
            $scope.loadBooks();
        });
    };

    // $scope.loadBooks();
});

app.factory('AuthService', function($http){

    var service = {};

    service.loggedIn = false;

    service.login = function(authInfo, callback){
        $http({
            method: "POST",
            url : url+"/login",
            data: authInfo
        }).then(function(response){
            service.loggedIn = response.status == 200;
            callback(response);
        });
    };

    service.logout = function(){
        service.loggedIn = false;
    };

    return service;

});

app.factory('BackendService', function($http){

    var service = {};

    service.getBooks = function(callback){
        $http({
            method : "GET",
            url : url+"/getBooks"
        }).then(function(response){
            //https://docs.angularjs.org/api/ng/service/$http for more info on the response object
            callback(response);
        });
    };

    service.borrowBook = function(bookId, callback){
        $http({
            method: "POST",
            url : url+"/borrowBook",
            data: bookId
        }).then(function(response){
            callback(response);
        });
    };

    service.returnBook = function(bookId, callback){
        $http({
            method: "POST",
            url : url+"/returnBook",
            data: bookId
        }).then(function(response){
            callback(response);
        });
    };

    service.getBook = function(id, callback){
        $http({
            method : "GET",
            url : url+"/getBook/"+id
        }).then(function(response){
            //https://docs.angularjs.org/api/ng/service/$http for more info on the response object
            callback(response);
        });
    };

    return service;
});