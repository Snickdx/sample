var app = angular.module('sample', ['ui.bootstrap', 'ui.router']);

var url = "http://162.243.52.181/sample/backend/index.php";

app.config(function($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('authors', {
            url: '/authors',
            views: {
                nav: {
                    templateUrl: 'templates/navbar.html',
                    controller: 'navBarController'
                },
                content: {
                    templateUrl: 'templates/authors.html'
                }
            },
            controller:"authorController"

        })
        .state('books', {
            url: '/books',
            views: {
                nav: {
                    templateUrl: 'templates/navbar.html',
                    controller: 'navBarController'
                },
                content: {
                    templateUrl: 'templates/books.html',
                    controller:"bookController"
                }
            }
        })
        .state('login', {
            url: '/',
            views: {
                content: {
                    templateUrl: 'templates/login.html',
                    controller:"loginController"
                }

            }
        });
    $urlRouterProvider.otherwise('/');
});

app.controller('bookController', function($scope, AuthService, BackendService){

    $scope.input = {
        returnedBook: "Select Option"
    };

    $scope.userId = AuthService.userId;

    // $scope.books = [
    //     {
    //         bookId: 1,
    //         author:"bob",
    //         published: "yesterday",
    //         title:"kek"
    //     },
    //     {
    //         bookId: 2,
    //         author:"bob",
    //         published: "today",
    //         title:"kek2",
    //         borrowedBy: 3
    //     },
    //     {
    //         bookId: 3,
    //         author:"janis",
    //         published: "sometime",
    //         title:"kek3",
    //         borrowedBy: 1
    //     },
    //     {
    //         bookId: 4,
    //         author:"janis",
    //         published: "sometime",
    //         title:"kek4",
    //         borrowedBy: 1
    //     }
    // ];

    $scope.books = [];

    $scope.loadBooks = function(){
        BackendService.getBooks(function(response){
            $scope.books = response.data;
        });
    };
    
    $scope.borrowBook = function(id){
        BackendService.borrowBook(id, $scope.userId, function(response){
            if(response.status == 200){
                console.log("success");
            }else{
                console.log("error");
            }
            $scope.loadBooks();
        });
    };

    $scope.returnBook = function(){
        BackendService.returnBook($scope.input.returnedBook, $scope.userId, function(response){
            if(response.status == 200){
                console.log("success");
            }else{
                console.log("error");
            }
            $scope.input.returnedBook = "Select Option";
            $scope.loadBooks();
        });
    };

    $scope.loadBooks();
});

app.controller('loginController', function($scope, AuthService, $location){
    console.log("in login");

    $scope.input = {
        username: "",
        password: ""
    };

    $scope.signIn = function(){
        AuthService.login($scope.input, function(response){
            console.log(response);
            $scope.userId = response.data[0].userId;
            if(response.stats = 200){
                $location.path("/books");
            }else{
                $location.path("/");
            }
        })
    };

});

app.controller('authorController', function($scope, BackendService){});

app.controller('navBarController', function($scope, BackendService, AuthService){
    
    $scope.userId = AuthService.getId();
    
    console.log($scope.userId);
    
    $scope.books = [];

    $scope.loadBooks = function(){
        BackendService.getBooks(function(response){
            $scope.books = response.data;
            console.log($scope.books);
        });
    };
    
    $scope.logout = function(){
        $scope.loggedIn = false;
    };
    
    $scope.loadBooks();
});

app.factory('AuthService', function($http){

    var service = {};

    service.userId = null;

    service.loggedIn = false;

    /**
     * Logins In a user
     * @param authInfo object {username : "username", password "password}
     * @param callback
     */
    service.login = function(authInfo, callback){
        $http({
            method: "POST",
            url : url+"/login",
            data: authInfo
        }).then(function(response){
            service.loggedIn = response.status == 200;
            service.userId = response.data[0].userId;
            console.log(service.userId);
            callback(response);
        });
    };
    
    service.getId = function(){
        return service.userId;
    }

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

    service.borrowBook = function(bookId, userId, callback){
        $http({
            method: "POST",
            url : url+"/borrowBook",
            data: {bookId : bookId, userId: userId}
        }).then(function(response){
            callback(response);
        });
    };

    service.returnBook = function(bookId, userId, callback){
        $http({
            method: "POST",
            url : url+"/returnBook",
            data: {bookId : bookId, userId: userId}
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
