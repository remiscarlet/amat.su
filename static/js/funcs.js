


function generateLink(shortURL){
  var urlBox = $("#newUrl");
  console.log(urlBox);
  console.log(shortURL)
  urlBox.html(shortURL);
}

$(document).ready(function () {
  $("#urlForm").submit(function() {
      var url;
      var csrf = $("[name='csrfmiddlewaretoken']").val();
      //console.log(csrf);
      $.post("/api/", {csrfmiddlewaretoken:csrf,url:$("#url").val()})
      .done(function (data){
        generateLink(data);
      });
      return false;
  });

});