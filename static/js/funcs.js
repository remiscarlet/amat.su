
function generateLink(shortURL){
  var urlBox = $("#output");
  console.log(urlBox);
  console.log(shortURL);
  urlBox.val(shortURL);
}

function changeBackText(){
  $("#copyButton").html("Copy");
};


function urlCallback(){
  var url;
  var csrf = $("[name='csrfmiddlewaretoken']").val();
  var custom = $("#customURL").val();
  console.log(custom);
  $.post("/api/", {csrfmiddlewaretoken:csrf,url:$("#url").val(),customURL:custom})
  .done(function (data){

    var addKaze = $('#addKaze').is(":checked");
    if (addKaze){
      var split = data.split("/")
      data = "http://amat.su/kaze/"+split[3];
    }
    generateLink(data);
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