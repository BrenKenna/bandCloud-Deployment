
// Send form data as JSON
function sendForm(){

    let msg = JSON.stringify({
        username: $("#uname").val(),
        password: $("#pass").val()
    });
    
    $.ajax({
        type: 'POST',
        url: '/login',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: msg,
        cache: false,
        success: function( response, textStatus, jQxhr ) {
            setTimeout(console.log(`I just sent: ${msg}`), 2000);
            console.log(response);
            console.log(textStatus);
            console.dir(jQxhr, {depth: null});
        }
    });
}