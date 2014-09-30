(** Basic type and event definitions. *)
Require Import Coq.Lists.List.
Require Import Coq.NArith.NArith.
Require Import Coq.Strings.String.
Require Import String.

Import ListNotations.
Open Local Scope type.
Open Local Scope string.

Module ClientSocketId.
  Inductive t : Set :=
  | New : N -> t.
End ClientSocketId.

Module Command.
  Inductive t : Set :=
  | Log
  | FileRead
  | ServerSocketBind
  | ClientSocketRead | ClientSocketWrite.

  (** The type of the parameters of a request. *)
  Definition request (command : t) : Set :=
    match command with
    | Log => string
    | FileRead => string
    | ServerSocketBind => N
    | ClientSocketRead => ClientSocketId.t
    | ClientSocketWrite => ClientSocketId.t * string
    end.

  (** The type of the parameters of an answer. *)
  Definition answer (command : t) : Set :=
    match command with
    | Log => bool
    | FileRead => option string
    | ServerSocketBind => option ClientSocketId.t
    | ClientSocketRead => option string
    | ClientSocketWrite => bool
    end.
End Command.

Module Input.
  Record t : Set := New {
    command : Command.t;
    id : N;
    argument : Command.answer command }.
End Input.

Module Output.
  Record t : Set := New {
    command : Command.t;
    id : N;
    argument : Command.request command }.
End Output.