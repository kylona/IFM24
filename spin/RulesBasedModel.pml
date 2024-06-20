mtype = { Send, Recieve, SendRef, ReceiveRef,
	  promise, status, commit, void, signature}
typedef Action {
  mtype type;
  mtype message;
  int source;
  int dest;
}

chan acts = [6] of { Action }

#define NONE -1
#define ORIGINATOR 0
#define RELAY 1

inline addSend() {
    atomic {
        Action act;
        act.type = Send;
        if
        :: true ->
          act.message = promise
        :: true ->
          act.message = void
        :: true ->
          act.message = signature
        fi
        if
        :: true ->
          act.source = ORIGINATOR
          act.dest = RELAY
        :: true ->
          act.source = RELAY
          act.dest = ORIGINATOR
        fi
        acts!act; //put it in their succ box (if they are my pred I am their succ)
    }
}

inline addReceive() {
    atomic {
        Action act;
        act.type = Recieve;
        if
        :: true ->
          act.message = promise
        :: true ->
          act.message = void
        :: true ->
          act.message = signature
        fi
        if
        :: true ->
          act.source = NONE
          act.dest = RELAY
        :: true ->
          act.source = NONE
          act.dest = ORIGINATOR
        fi
        acts!act; //put it in their succ box (if they are my pred I am their succ)
    }
}

inline addSendRef() {
    atomic {
        Action act;
        act.type = SendRef;
        if
        :: true ->
          act.message = commit
        :: true ->
          act.message = status
        fi
        if
        :: true ->
          act.source = ORIGINATOR
          act.dest = NONE
        :: true ->
          act.source = RELAY
          act.dest = NONE
        fi
        acts!act; //put it in their succ box (if they are my pred I am their succ)
    }
}

inline addReceiveRef() {
    atomic {
        Action act;
        act.type = ReceiveRef;
        if
        :: true ->
          act.message = void
        :: true ->
          act.message = signature
        fi
        if
        :: true ->
          act.source = NONE
          act.dest = ORIGINATOR
        :: true ->
          act.source = NONE
          act.dest = RELAY
        fi
        acts!act; //put it in their succ box (if they are my pred I am their succ)
    }
}

init {
  do
  :: nfull(acts) ->
    printf("Adding Send\n")
    addSend()
  :: nfull(acts) ->
    printf("Adding Receive\n")
    addReceive()
  :: nfull(acts) ->
    printf("Adding SendRef\n")
    addSendRef()
  :: nfull(acts) ->
    printf("Adding ReceiveRef\n")
    addReceiveRef()
  :: true ->
    break
  od
}

ltl p1 {always eventually true}
