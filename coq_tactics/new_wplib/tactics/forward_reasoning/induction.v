(** * induction.v
Author: 
    - Cosmin Manea (1298542)
Creation date: 06 June 2021

Tactic for proving by mathematical induction.
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

(** * induction_with_hypothesis_naming
    Performs mathematical induction.

    Arguments:
        - [x: ident], the variable to perform the induction on.
        - [y: ident], the name of the induction hypothesis.

    Does:
        - performs induction on [x].
*)
Local Ltac2 induction_with_hypothesis_naming (x: ident) (y: ident) :=
    let x_val := Control.hyp x in induction $x_val.


Ltac2 Notation "We" "prove" "by" "induction" "on" x(ident) "," 
               "calling" "the" "induction" "hypothesis" y(ident) := 
    induction_with_hypothesis_naming x y.
