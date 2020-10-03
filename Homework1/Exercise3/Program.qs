namespace Exercise3 {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    /// # Summary
    /// Given two qubit registers as arguments, `x` and `y`, leaves the state of register `x` constant
    /// and changes the state of register `y` to be `|y + x>`.
    /// The operation receives `LittleEndian` registers to identify the most and least significant bigs.
    operation AddInPlace(x: LittleEndian, y: LittleEndian, carry : Qubit) : Unit
    is Adj + Ctl {
        // ...
    }


    /// # Summary
    /// This is the entry-point for the Q# program. It takes two integers that will be added in place.
    /// To invoke this from the command line do:
    ///
    ///     dotnet run -- -x 10 -y 2
    ///    @EntryPoint()
    operation Main(x: Int, y: Int) : Int {
        let n = 4;

        using ((xQubits, yQubits, carry) = (Qubit[n], Qubit[n], Qubit()))
        {
            let registerX = LittleEndian(xQubits); // define bit order
            let registerY = LittleEndian(yQubits);

            // TODO: set registers to correct value.
            // HINT: https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arithmetic.applyxorinplace
            
            AddInPlace(registerX, registerY, carry); // perform addition x+y into y
            
            // Set qubits back to 0 before releasing:
            ResetAll(xQubits);
            Reset(carry);

            return MeasureInteger(registerY);
        }
    }
}

