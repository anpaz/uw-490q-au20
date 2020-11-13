namespace p2 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    

    operation Entangle(q1: Qubit, q2: Qubit) : Unit {
        H(q1);
        CNOT(q1, q2);
    }

    operation EncodeBits(q: Qubit, b1: Bool, b2: Bool) : Unit {
        if (b2) {
            X(q);
        }
        if (b1) {
            Z(q);
        }
    }

    operation DecodeBits(q1: Qubit, q2: Qubit) : (Result, Result) {
        CNOT(q1, q2);
        H(q1);

        return (M(q1), M(q2));
    }

    @EntryPoint()
    operation Main(b1: Bool, b2: Bool) : Unit {
        using ((q1, q2) = (Qubit(), Qubit())) {
            Entangle(q1, q2);

            EncodeBits(q1, b1, b2);
            let result = DecodeBits(q1, q2);

            Message($"result: {result}");
        }
    }
}
