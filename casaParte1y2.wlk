// EJERCICIO 1
object casa {
    var cuenta = cuentaCorriente
    var totalDeGastosEnElMes = 0 //contador de gastos

    //getter
    method cuentaActual() {
      return cuenta
    }

    //setter
    method cuentaActual(_cuenta) {
        cuenta = _cuenta
    }

    // Cada vez que se produce un gasto, se extrae de la cuenta asignada el importe correspondiente.
    // Además, se necesita recordar el monto total de gastos realizados durante el mes.
    method gastar(monto) {
        cuenta.extraerEnCuenta(monto)
        totalDeGastosEnElMes = totalDeGastosEnElMes + cuenta.extraerEnCuenta(monto) //actualizo el total de los gastos
    }

    //getter - saber el monto total gastado en la casa durante el mes actual.  
    method totalDeGastosEnElMes() {
        return totalDeGastosEnElMes
    }

    // indicar que cambió el mes - se resetea la variable de gastos en el mes 
    method cambioDeMes(){
        totalDeGastosEnElMes = 0
    }
}

object cuentaCorriente {
    //al depositar suma el nuevo monto al saldo, y al extraer, resta. Permite saldos negativos sin límite.
    var saldoCuentaCorriente = 0

    //getter
    method saldoDeCuenta() {
      return saldoCuentaCorriente
    }

    method depositarEnCuenta(monto) {
        saldoCuentaCorriente = saldoCuentaCorriente + monto
    }

    method extraerEnCuenta(monto) {
      saldoCuentaCorriente = saldoCuentaCorriente - monto
    }
}

object cuentaConGastos {
    //mantiene un saldo y, además, un costo por operación. Al depositar, suma el importe indicado menos el costo 
    //por operación. Al extraer, resta normalmente. También permite saldo negativo, pero 
    //no permite un depósito de un monto menor o igual al costo de operación.
    var saldoCuentaConGastos = 0
    var costoDeOperacion = 0

    //getter
    method saldoDeCuenta() {
      return saldoCuentaConGastos
    }

    //getter
    method costoDeOperacion() {
      return costoDeOperacion
    }

    //setter
    method costoDeOperacion(_costoDeOperacion) {
      costoDeOperacion = _costoDeOperacion
    }

    //metodo de "testeo interno" visto en clase
    method depositarEnCuenta(monto) {
        self.validarMonto(monto) //porque no permite un depósito de un monto menor o igual al costo de operación.
        saldoCuentaConGastos = saldoCuentaConGastos + monto - costoDeOperacion
    }

    method validarMonto(monto) {
      if ( monto <= costoDeOperacion ) {
        self.error("El monto debe ser mayor al costo de operación")
      }
    }

    method extraerEnCuenta(monto) {
      saldoCuentaConGastos = saldoCuentaConGastos - monto
    }
}

// EJERCICIO 2
object cuentaCombinada {
  var cuentaPrimaria = cuentaConGastos
  var cuentaSecundaria = cuentaCorriente

  //setter
  method cuentaPrimaria(_cuentaPrimaria) {
    cuentaPrimaria = _cuentaPrimaria
  }

  //setter
  method cuentaSecundaria(_cuentaSecundaria) {
    cuentaSecundaria = _cuentaSecundaria
  }

  method saldoCuentaPrimaria() {
    return 0.max(cuentaPrimaria.saldoDeCuenta()) // el mayor número entre 0 y el saldo de la cuenta primaria
  }

  method saldoCuentaSecundaria() {
    return 0.max(cuentaSecundaria.saldoDeCuenta()) // el mayor número entre 0 y el saldo de la cuenta secundaria
  }

  //sumatoria de saldos
  method saldoDeCuenta() {
    return self.saldoCuentaPrimaria() + self.saldoCuentaSecundaria()
  }

  // Si se deposita, el importe va a la cuenta primaria
  method depositarEnCuenta(monto) {
    cuentaPrimaria.depositarEnCuenta(monto)
  }

  // Si se extrae: Primero se descuenta de la cuenta primaria todo lo posible, sin dejarla en negativo
  // Lo que reste pagar se descuenta de la cuenta secundaria
  method extraerEnCuenta(monto) {
    self.validarMonto(monto)
    cuentaPrimaria.extraerEnCuenta(monto)
    //..........
  }

  //metodo de "testeo interno" 
  method validarMonto(monto) {
      if ( monto > self.saldoDeCuenta() ) {
        self.error("El monto excede el saldo de la cuenta")
      }
    }
}