# Ruby livecoding

## Regular expressions

## Collections and functional idioms (collections.rb)

* Try `each` on an array.  Then on a string. Why does it work? Mix ins!

* Demo: how would you sort bank accounts? 
  * Sorting is defined in Enumerable, but also relies on Comparable.  So
  the receiver of `sort` must be enumerable via `each`, and the elements
  of the collection returend by `each` must be comparable.
  * So - add comparison to bank accounts!
  * This is "Ruby thinking"

## Metaprogramming

## Yield

* What does `each` really do?  It yields one element of a collection at
a time, handing it to the lambda (procedure) that is the argument of
`each` itself!
* Strings don't have a built-in sort function, but we know that sorting
is available in `Enumerable` as long as the receiver object can respond
to `each`, and each yielded object can respond to `<=>`.  Is this true
for strings?  Let's try it.
  * No `each`, so we must define it. What if we made strings yield one
  character at a time?  If each character was yielded as a string of
  length 1, we know we can compare them.  So we just need to define
  `each` on strings, and include `Enumerable` to get the `sort` method
