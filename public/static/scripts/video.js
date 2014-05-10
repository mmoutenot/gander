var session = OT.initSession(tokKey, sessionId);

session.on("streamCreated", function(event) {
  session.subscribe(event.stream);
});

session.on("sessionConnected", function(event) {
  var publisher = OT.initPublisher();
  session.publish(publisher);
}).connect(token, function(error) {
});
