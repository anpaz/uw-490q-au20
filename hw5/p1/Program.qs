namespace problem1 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    

    operation RandomBit() : Result {
        using(q = Qubit()) {
            H(q);
            return M(q);
        }
    }

    @EntryPoint()
    operation SayHello() : Unit {        
        for (i in 0..9) {
            let r = RandomBit();
            Message($"[{i}]: {r}");
        }
    }
}
