namespace Exercise1 {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    /// # Summary
    /// Given two qubits in state |00>, 
    /// prepare a Bell state  |+⟩ =1/√2(|00⟩+|11⟩) on these qubits.
    operation PrepareBellState(q1: Qubit, q2: Qubit) : Unit 
    is Adj + Ctl {
        // ...
    }

    /// # Summary
    /// Encode the message (two classical bits) in the state of a single qubit.
    operation EncodeMessage (q1 : Qubit, (bit1: Bool, bit2: Bool)) : Unit 
    is Adj + Ctl {
        // ...
    }


    
    /// # Summary
    /// Given two entangled qubits, returns the encoded classical message in them.
    operation DecodeMessage (q1 : Qubit, q2: Qubit) : (Result, Result) 
    {
        //TODO:
        return (Zero, Zero);
    }


    /// # Summary
    /// This is the entry-point for the Q# program. It should implement the superdense protocol end-to-end.
    ///
    /// To invoke this from the command line do:
    ///
    ///     dotnet run -- --bit1 true --bit2 false
    ///
    @EntryPoint()
    operation Main(bit1: Bool, bit2: Bool) : (Result, Result) 
    {
        // TODO: 
        //   - allocate qubits
        //   - call PrepareBellState
        //   - call EncodeMessage

        //TODO: return the value from DecodeMessage
        return (Zero, Zero);

    }
}

