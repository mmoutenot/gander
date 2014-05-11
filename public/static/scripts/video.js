$(function(){
  var session = OT.initSession(tokKey, sessionId);
  var publisher;

  session.on("streamCreated", function(event) {
    session.subscribe(event.stream);
  });

  session.on("streamDestroyed", function(event) {
    $('body').append("<h3 style=\"color:white;\">Completed</h3>");
  });

  session.on("sessionConnected", function(event) {
    if(session.capabilities.publish) {
      publisher = OT.initPublisher();
    }
  });

  session.connect(token, function(error) {
  });

  $('.js-broadcast').click(function() {
    if (publisher) {
      session.publish(publisher);
    }
  });

  $('.js-stop').click(function() {
    $.post('/session/' + sessionId + '/complete', function(){
      session.unpublish(publisher);
    });
  });
});
