library(httpuv)
library(RJSONIO)
library(R.utils)

assign("myws", NULL, .GlobalEnv)
assign(".lastMessage", NULL, .GlobalEnv)
fpath <- system.file(c("inst", "www"), "listRed.html", package="listRed")
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
      body = c(file=fpath))
  },
  onWSOpen = function(ws) {
    assign("myws", ws, .GlobalEnv)
    ws$onMessage(function(binary, rawMessage) {
      message <- fromJSON(rawMessage);
      assign(".lastMessage", message, .GlobalEnv)
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
stopws <- function(server){
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
  assign(".lastMessage", NULL, .GlobalEnv)
  myws$send(toJSON(list(cmd="returnList", callback="handleReturn",payload="")));
  while(is.null(.lastMessage)) {
    Sys.sleep(1)
  }
  .lastMessage
}
#-------------------------------------------------------------------------------
handleReturn <- function(message)
{
  assign(".lastMessage", message$payload, .GlobalEnv)
  NULL  
}
#-------------------------------------------------------------------------------