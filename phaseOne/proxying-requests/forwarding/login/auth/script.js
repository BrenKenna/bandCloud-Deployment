
// Send form data as JSON
// Content Type = What is sent
// Data Type = What is recieved
function sendForm(){

    let msg = JSON.stringify({
        username: $("#uname").val(),
        password: $("#pass").val()
    });
    
    $.ajax({
        type: 'post',
        url: '/login',
        dataType: 'html',
        contentType: 'application/json; charset=utf-8',
        data: msg,
        cache: false,
        success: function( response, textStatus, jQxhr ) {

            // Load the response page
            $('html').html(response);
        }
    });
}