namespace p2 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    

    operation Entangle(q1: Qubit, q2: Qubit) : Unit {
        H(q1);
        CNOT(q1, q2);
    }

    @EntryPoint()
    operation SayHello() : Unit {
        for (i in 0..9) {
            using ((q1, q2) = (Qubit(), Qubit())) {
                Entangle(q1, q2);

                let r1 = M(q1);
                let r2 = M(q2);
                Message($"[{i}]: {r1},{r2}");
            }
        }
    }
}
