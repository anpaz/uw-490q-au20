namespace Exercise2 {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    /// # Summary
    /// Implements the `f(x) = 1` oracle. That is, regardless of 
    /// input `x`, the `y` Qubit is always transformed to be `|y + 1>`
    operation Oracle_One(x : Qubit[], y: Qubit) : Unit
    is Adj + Ctl {
        // ...
    }

    /// # Summary
    /// Implements the `f(x_k) = 1` oracle. That is, 
    /// the `y` Qubit is transformed to be `|y + 1>` if the state of
    /// k-th qubit is `|1>`
    operation Oracle_Kth_Qubit(x : Qubit[], k: Int, y: Qubit) : Unit
    is Adj + Ctl {
        // ...
    }

    /// # Summary
    /// Implements the `f(x) = 1 iff x contains odd number of qubits in state |1>` oracle. That is, 
    /// the `y` Qubit is transformed to be `|y + 1>` iff the number of qubits in the x register in state |1>
    /// is odd.
    ///
    /// > HINT: 𝑓(𝑥)  can be represented as  𝑥0⊕𝑥1⊕...⊕𝑥𝑁−1 .
    operation Oracle_Odd(x : Qubit[], y: Qubit) : Unit
    is Adj + Ctl {
        // ...
    }


    /// # Summary
    /// This is the entry-point for the Q# programs. It takes a couple of parameters to 
    /// to help testing the oracles.
    /// To invoke this from the command line do:
    ///
    ///     dotnet run -- -v 10 -k 2
    ///
    @EntryPoint()
    operation Main(v: Int, k: Int) : Unit {
        let N = 4;  // Number of qubits

        // A quick check that we have valid inputs
        EqualityFactB(0 <= v and (v < 16), true, $"Input value should be between 0 and 16");
        EqualityFactB(0 <= k and k < N, true, $"k should be between 0 and {N-1}, inclusive");

        using ((x, y) = (Qubit[N], Qubit())) {
            EncodeValueInArray(x, v);

            Oracle_One(x, y);
            Message($"  --> Oracle_One returned: {M(y)}");

            Reset(y);
            Oracle_Kth_Qubit(x, k, y);
            Message($"  --> Oracle_Kth_Qubit returned: {M(y)}");

            Reset(y);
            Oracle_Odd(x, y);
            Message($"  --> Oracle_Odd returned: {M(y)}");
            
            ResetAll(x);
            Reset(y);
        }
    }

    /// # Summary
    /// This is a helper operation that encodes the given value
    /// into the x array.
    operation EncodeValueInArray(x: Qubit[], value: Int) : Unit {
        for(i in 0 .. Length(x) - 1) {
            if (((value >>> i ) &&& 1) == 1) {
                Message($"Setting qubit {i}");
                X(x[i]);
            }
        }
    }
}

