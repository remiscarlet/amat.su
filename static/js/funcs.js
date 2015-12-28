
function generateLink(shortURL){
  var urlBox = $("#output");
  console.log(urlBox);
  console.log(shortURL);
  urlBox.val(shortURL);
}



$(document).ready(function () {
  var clipboard = new Clipboard('.btn');

  clipboard.on('success', function(e) {
      $("#copyButton").html("Copied!")

  });
  clipboard.on('error', function(e) {
      console.error('Action:', e.action);
      console.error('Trigger:', e.trigger);
  });

  $("#urlForm").submit(function() {
      var url;
      var csrf = $("[name='csrfmiddlewaretoken']").val();
      $.post("/api/", {csrfmiddlewaretoken:csrf,url:$("#url").val()})
      .done(function (data){
        generateLink(data);
      });
      return false;
  });
});