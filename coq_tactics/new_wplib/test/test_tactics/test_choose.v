(** * test_choose.v
Authors: 
    - Cosmin Manea (1298542)

Creation date: 30 May 2021

Testcases for the two [Choose] tactics.
Tests pass if they can be run without unhandled errors.
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
Load Choose.
Load test_auxiliary.


(** Test 0: This should choose m equal to n *)
Goal forall n : nat, exists m : nat, n = m.
Proof.
  intros.
  Choose m := n.
  reflexivity.
Qed.


(** Test 1: This should choose m equal n implicitly *)
Goal forall n : nat, exists m : nat, n = m.
    intro n.
    Choose (n).
    reflexivity.
Qed.


(** Test 2: This should choose m equal to 1 *)
Goal exists m : nat, m = 1.
    Choose m := 1.
    reflexivity.
Qed.


(** Test 3: This should raise an error, as the goal is not an exists goal *)
Goal forall n : nat, ( ( (n = n) \/ (n + 1 = n + 1) ) -> (n + 1 = n + 1)).
    intro n.
    assert_raises_error (fun() => Choose (n)).
Abort.


(** Test 4: This should also raise an error, as the goal is not an exists goal *)
Goal forall n : nat, ( ( (n = n) \/ (n + 1 = n + 1) ) -> (n + 1 = n + 1)).
    intro n.
    assert_raises_error (fun() => Choose m := n).
Abort.