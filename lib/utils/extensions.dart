V takeValue<U, V>(final U value, final V Function(U) fn) => fn(value);
