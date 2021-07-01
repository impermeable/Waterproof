(** * claims.v
Author: 
    - Cosmin Manea (1298542)
Creation date: 06 June 2021

Tactic for claiming a specific result. This allows the user to prove a sublemma within a proof.
--------------------------------------------------------------------------------

This file is part of Waterproof-lib.

Waterproof-lib is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Waterproof-lib is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Waterproof-lib.  If not, see <https://www.gnu.org/licenses/>.
*)


From Ltac2 Require Import Ltac2.

Add LoadPath "C:/Users/cosmi/Desktop/SEP - CM forward reasoning/waterproof/coq_tactics/new_wplib/" as wplib.
Load auxiliary.

Ltac2 Notation "We" "claim" "that" t(constr) "(" u(ident) ")" :=
    Aux.ltac2_assert u t.