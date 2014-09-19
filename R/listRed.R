library(httpuv)
library(RJSONIO)
library(R.utils)

myws <- NULL
.lastMessage <- NULL

#-------------------------------------------------------------------------------
app <- list(
  call = function(req) {
    wsUrl = paste(sep='',
                  '"',
                  "ws://",
                  ifelse(is.null(req$HTTP_HOST), req$SERVER_NAME, req$HTTP_HOST),
                  '"')
    list(
      status = 200L,
      headers = list('Content-Type' = 'text/html'),
      body = c(file="/www/listRed.html"))
  },
  onWSOpen = function(ws) {
    myws <<- ws
    ws$onMessage(function(binary, rawMessage) {
      message <- fromJSON(rawMessage);
      .lastMessage <<- message
      if(!is(message, "list")){
        printf("new websocket message is not a list");
        return;
      }
      if (! "cmd" %in% names(message)){
        printf("new websocket messages has no 'cmd' field");
        return;
      }
      cmd <- message$cmd
      if(cmd == "handleReturn"){
        handleReturn(message)
      }
      else{
        printf("unrecognized incoming command: %s",  cmd);
      }
    })
  }
)
#-------------------------------------------------------------------------------
go <- function(){
  port <- 9454
  browseURL(sprintf("http://localhost:%d", port))
  server <- startDaemonizedServer("0.0.0.0", port, app)
}
#-------------------------------------------------------------------------------
stopit <- function(server){
  stopDaemonizedServer(server)
}
#-------------------------------------------------------------------------------
send <- function(cmd)
{
  myws$send(toJSON(cmd)) 
}
#-------------------------------------------------------------------------------
sendList <- function(mylist)
{
  msg <- list(cmd="sendList", payload=mylist)
  myws$send(toJSON(msg))
}
#-------------------------------------------------------------------------------
returnList <- function()
{
  .lastMessage <<- NULL
  myws$send(toJSON(list(cmd="returnList", callback="handleReturn",payload="")));
  while(is.null(.lastMessage)) {
    Sys.sleep(1)
  }
  .lastMessage
}
#-------------------------------------------------------------------------------
handleReturn <- function(message)
{
  .lastMessage <<- message$payload
  NULL  
}
#-------------------------------------------------------------------------------