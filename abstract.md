No Compiler Required: Hand-Rolling C++20 Coroutines in C++17

How does co_await actually work? Not only at the "promise_type customization point" level, but at the level of the state machine the compiler emits on your behalf.
In this talk, we will take C++20 coroutines apart by manually transforming them into equivalent C++17 state machines, starting with a simple generator and building up to coroutines involving symmetric transfer and exception propagation. Each transformation exposes a subtlety that is easy to overlook when the compiler does the work for us: coroutine frame layout, suspension point indexing, lifetime of locals across suspension points, and the surprisingly tricky semantics of initial_suspend and final_suspend. By the end, you will have a mental model precise enough to reason about compiler codegen, debug coroutine-related issues, and evaluate the design tradeoffs baked into the C++20 coroutine specification.

Because the transformations only touch the coroutine body (the promise_type, awaitables, and other customization points remain virtually unchanged) the coroutine infrastructure itself becomes a library-level concern, and we can change it. We demonstrate this by swapping the default stackless machinery for a stackful alternative that, for simple generators, matches the performance of handwritten iterators and ranges. Finally, we show that the tedious manual rewriting can be automated with a source-to-source rewriter built on LLVM's LibTooling, making a case for why reimplementing core language features as library code can be practically valuable even when the compiler already provides them.


Outline

Refresher — coroutine_handle, promise_type, and the compiler-generated state machine in 5 minutes.

Manual coroutine infrastructure — A custom coroutine_handle equivalent and a CRTP base class encapsulating frame layout and state-machine dispatch.

Four hand-lowered coroutines (using the infrastructure from §2):

(a) A minimal int-yielding generator — no locals, no exceptions.
(b) A generator with local variables — lifetime management across suspension points.
(c) A task-based example with co_await in a loop — demonstrating symmetric transfer.
(d) try/catch in the coroutine body — manually implementing stack unwinding in user space.
The four examples can be reviewed anonymously at https://github.com/anonymousscientist491/coroutine-rewrite-examples.

Stackful coroutine infrastructure -- Alternative implementation of the infrastructure from 3. that stores the whole coroutine frame inside a fat templated coroutine_handle, which directly lets our generator match the performance of a handwritten range.

Automatic rewriting with LibTooling — Demo and overview of a source-to-source C++20→C++17 coroutine rewriter; focus on limitations (nested co_await, unspecified evaluation order, and one lifetime edge case that appears impossible to express purely in source).

Why rewrite language features as library code? — Brief discussion of when manual or automated rewrites are valuable in practice and whether they belong in production.
