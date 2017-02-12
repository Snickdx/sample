var url = "http://162.243.52.181/sample/backend/index.php/";

$(document).ready(function(){

    $("#booksContainer").hide();

    $("#signInBtn").click(function(){
        signIn(function(userId)
        {
            $("#signUpContainer").hide();
            $("#booksContainer").show();

            loadBooks(userId);

            $("#returnBtn").click(function(){
                var bookId = $("#bookSelect").val();
                console.log(bookId, userId);
                returnBook(bookId, userId);
            });
        });
    });




});

function loadBooks(userId){

    $.ajax({
        type: "GET",
        url: url+"getBooks",
        success: function(books){
            books = JSON.parse(books);
            console.log(books);
            showBooks(books);
            $(".borrowBtn").click(function(){
                console.log(userId);
                borrowBook($(this).attr('id'), userId);
            });
            showOptions(books, userId);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert("some error");
        }
    });

}

function borrowBook(bookId, userId){
    //api call to borrow book
    $.ajax({
        type: "POST",
        url: url+"borrowBook",
        data: {bookId : bookId, userId: userId},
        succss: function(resp){
            console.log(resp);
            loadBooks(userId);
        }
    });
}

function returnBook(bookId, userId){

    $.ajax({
        type: "POST",
        url: url+"returnBook",
        data: {bookId : bookId, userId: userId},
        success: function (resp) {
            console.log(resp);
            loadBooks(userId);
        }
    });


}

function signIn(callback){
    var username = $("#username").val();
    var password = $("#password").val();

    $.ajax({
        type: "POST",
        url: url+"login",
        data: {username : username, password: password},
        success: function(response){
            response = JSON.parse(response)[0];
            callback(response.userId);
        },
        error: function(){
            alert("Invalid Login");
        }
    });

}

function showOptions(books, id){
    var html = `<option value="Select Option" selected>Select Book</option>`;
    books.forEach(function(book){
        if(book.borrowedBy != undefined && book.borrowedBy == id)html += `<option  value='${book.bookId}'>${book.title}</option>`;
    });
    $("#bookSelect").html(html);

}

function showBooks(books){
    var html = ``;
    books.forEach(function(book){
        html+=`
            <div class="card text-left" style="margin-bottom: 4px; min-height: 230px">
                    <div class="card-block" >
                        <h4 class="card-title">${book.title}</h4>
                        <p class="card-text">Author: ${book.author}</p>
                        <p class="card-text">Published: ${book.published}</p>
                        <p class="card-text">${book.borrowedBy ? "Borrowed": "Available"}</p>
                        ${book.borrowedBy == undefined ? `<input class="btn btn-primary borrowBtn" id="${book.bookId}" type="button" value="Rent">` : '' }
                    </div>
            </div>
        `;
    });
    $("#bookList").html(html);


}
