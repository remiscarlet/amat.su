
function generateLink(shortURL){
  var urlBox = $("#output");
  console.log(urlBox);
  console.log(shortURL);
  urlBox.val(shortURL);
  urlBox.attr("value",shortURL);
}



$(document).ready(function () {
  var clipboard = new Clipboard('.btn');

  clipboard.on('success', function(e) {
      console.info('Action:', e.action);
      console.info('Text:', e.text);
      console.info('Trigger:', e.trigger);

      $("#copyButton").html("Copied!")

  });

  clipboard.on('error', function(e) {
      console.error('Action:', e.action);
      console.error('Trigger:', e.trigger);
  });
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