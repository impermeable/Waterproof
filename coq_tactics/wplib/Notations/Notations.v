(** # **Definitions and Notations for Waterproof**

This file contains a list of additional notation that can be used in writing mathematical proofs.*)
Require Import Qreals.
Require Import Reals.
Require Import Rbase.
Require Import Rfunctions.
Require Import SeqSeries.
Require Import Rtrigo.
Require Import Ranalysis.
Require Import Integration.
Require Import micromega.Lra.
Require Import Omega.
Require Import Max.

Require Export wplib.Definitions.SetDefinitions.

Open Scope nat_scope.
Open Scope R_scope.
(** ## **Quantifiers**
Allow unicode characters ∀ and ∃ for readability.*)
Notation "'for' 'all' x .. y , P" := (forall x, .. (forall y, P) ..)
  (at level 200, x binder, y binder, right associativity,
  format "'[ ' '[ ' for  all  x .. y ']' , '//'  P ']'") : type_scope.

Notation "∀ x .. y , P" := (forall x, .. (forall y, P) ..)
  (at level 200, x binder, y binder, right associativity,
  only parsing) : type_scope.

Notation "'there' 'exists' x .. y , P " := (exists x, .. (exists y, P) ..)
  (at level 200, x binder, y binder, right associativity,
  format "'[ ' '[ ' there  exists  x .. y  ']' , '//'  P ']'") : type_scope.

Notation "∃ x .. y , P " := (exists x, .. (exists y, P) ..)
  (at level 200, x binder, y binder, right associativity,
  only parsing) : type_scope.

Notation "'fun' x .. y '↦' t" := (fun x => .. (fun y => t) ..)
  (at level 200, x binder, y binder, right associativity,
  format "'[ ' '[ ' 'fun' x .. y ']' '↦' '/' t ']'").
(** ## **Set symbols, implications**
The following notations deal with sets.*)
Notation "x ∨ y" := (x \/ y) (at level 85, right associativity) : type_scope.
Notation "x ∧ y" := (x /\ y) (at level 80, right associativity) : type_scope.
Notation "x → y" := (x -> y)
  (at level 99, y at level 200, right associativity,
   only parsing): type_scope.
Notation "x ⇒ y" := (x -> y)
  (at level 99, y at level 200, right associativity,
   only parsing): type_scope.
(* the notation below is fun, but is no good for functions *)
(* need to see if this can be adapted so it only uses
   this notation for propositions *)
(*Notation "'if' x 'then' y" := (x -> y)
  (at level 99, y at level 200, right associativity): prop_scope.*)
Notation "x ⇨ y" := (x -> y)
  (at level 99, y at level 200, right associativity): type_scope.

Notation "x ↔ y" := (x <-> y) (at level 95, no associativity): type_scope.
Notation "x ⇔ y" := (x <-> y) (at level 95, no associativity): type_scope.
Notation "¬ x" := (~x) (at level 75, right associativity) : type_scope.
(* TODO: the below definition doesn't work very nicely *)
Notation "x ↦ y" := (fun x => y) (at level 0).
(** ## **(In)equalities**
Allowing unicode characters for uniqualities.*)
Notation "x ≠ y" := (x <> y) (at level 70) : type_scope.

Notation "x ≤ y" := (le x y) (at level 70, no associativity) : nat_scope.
Notation "x ≥ y" := (ge x y) (at level 70, no associativity) : nat_scope.

Notation "x ≤ y" := (x <= y)%R (at level 70, no associativity) : R_scope.
Notation "x ≥ y" := (x >= y)%R (at level 70, no associativity) : R_scope.
(** ## **Scopes and coercions***)
Notation "'ℕ'" := (nat).
Notation "'ℤ'" := (Z).
Notation "'ℚ'" := (Q).
Notation "'ℝ'" := (R).

(** We use coercions to get around writing INR and IZR *)
Coercion INR: nat >-> R.
Coercion IZR: Z >-> R.
Coercion Q2R: Q >-> R.

(** Add field and lra to tactics to try automatically *)
Hint Extern 3 ( _ = _ ) => field : real.
Hint Extern 3 ( _ <= _ ) => lra : real.
Hint Extern 3 ( _ >= _ ) => lra : real.
Hint Extern 3 ( _ < _ ) => lra : real.
Hint Extern 3 ( _ > _ ) => lra : real.
(** ## **Sequences***)
Definition converges_to (a : ℕ → ℝ) (c : ℝ) :=
  ∀ ε : ℝ, ε > 0 ⇒
    ∃ N : ℕ, ∀ n : ℕ, (n ≥ N)%nat ⇒
      R_dist (a n) c < ε.

Notation "a ⟶ c" := (converges_to a c) (at level 20).

Definition convergence {M : Metric_Space} (a : ℕ → Base M) (c : Base M) :=
  ∀ ε : ℝ, ε > 0 ⇒
    ∃ N : ℕ, ∀ n : ℕ, (n ≥ N)%nat ⇒
      dist M (a n) c < ε.


Definition bounded {X : Metric_Space} (a : ℕ → Base X) :=
  ∃ q : Base X,
    ∃ M : ℝ, M > 0 ⇒
      ∀ n : ℕ, dist X (a n) q ≤ M.

Notation "a ⟶ c" := (convergence a c) (at level 20) : metric_scope.

Definition cv_implies_cv_abs_to_l_abs :=
  cv_cvabs.
(** ## Real numbers

We have to take care with the associative level.
When using this in rewrites, $<$, $>$, etc. should bind stronger.*)
Notation "| x |" := (Rabs x) (at level 69, x at level 200).
Notation "｜ x - y ｜" := (R_dist x y) (at level 69, x at level 48, y at level 48) : extra.
(** ## Subsets and intervals*)
Notation "{ x : R | P }" := (mk_subset_R (fun x : R => P)).

Notation "[ x , y ]" := { r : R | x <= r <= y }.
Notation "[ x , y )" := { r : R | x <= r <  y }.
Notation "( x , y ]" := { r : R | x <  r <= y }.
Notation "( x , y )" := { r : R | x <  r <  y }.

(** ## Suprema and infima*)
Notation is_sup := is_lub.
Notation is_bdd_above := bound.
(** ## Sums and series*)
Notation "'Σ' Cn 'equals' x" :=
  (infinite_sum Cn x) (at level 50).

(*Notation "'Σ' 'of' Cn 'up' 'to' n" :=
  (sum_f_R0 Cn n) (at level 50).
 (*Sum and series also defined in series.wpn. What to adapt?*)*)

Definition finite_triangle_inequalty :=
  sum_f_R0_triangle.
(** ## Functions*)
(** For the composition of a sequence and a function (e.g. for the sequence of measures of a sequence of sets):*)
(*Notation "μ ◦ C" :=
  (fun (n:ℕ) ↦ (μ (C n))) (at level 45).*)
(** ## Sets*)
Definition is_in {D : Set} := fun (A : (D → Prop)) ↦ (fun (x : D) ↦ A x).
Notation "x ∈ A" := (@is_in _ A x) (at level 50) : analysis_scope.
Notation "b 'seen' 'as' 'element' 'of' A 'by' u" :=
  (mk_element_R (is_in A) b u) (at level 50).


(* We might want a notation like the following to clean
   up the environment after using previous notation:
Notation "'element' 'of' 'ℝ' 'that' 'is' 'in' A" :=
  (elements_R_satisfying (is_in A)) (at level 50).
  (*only to clean up environment*)
*)
