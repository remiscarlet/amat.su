
function populateOutputBox(shortURL){
  var urlBox = $("#output");
  console.log(urlBox);
  console.log(shortURL);
  urlBox.val(shortURL);
}

function changeBackText(){
  $("#copyButton").html("Copy");
}


function urlCallback(){
  var url;
  var csrf = $("[name='csrfmiddlewaretoken']").val();
  var custom = $("#customSuffix").val();
  $.post("/api/", {csrfmiddlewaretoken:csrf,url:$("#url").val(),customSuffix:custom})
    .done(function (data){
      var addKaze = $('#addKaze').is(":checked");
      if (addKaze){
        var split = data.split("/");
        console.log(split);
        var tmp = window.location.href.split("/");
        var base_url = tmp[0] + "//" + tmp[2];
        data = base_url+"/kaze/"+split[3];
      }
      populateOutputBox(data);
    })
    .fail(function (data){
      populateOutputBox(data.responseText)
    });
}

$(document).ready(function () {
  var clipboard = new Clipboard('.clipboard');

  clipboard.on('success', function(e) {
      $("#copyButton").html("Copied!");
      setTimeout(changeBackText,3000);
  });
  clipboard.on('error', function(e) {
      console.error('Action:', e.action);
      console.error('Trigger:', e.trigger);
  });

});
