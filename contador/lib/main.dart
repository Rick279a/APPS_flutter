import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // tirar a fita vermelha do canto direito
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int contador = 0;

//numeros ++ e -- o setState é o que atualiza
  void decrement() {
    setState(() {
      contador--;
    });
    print(contador);
  }

  bool get isEmpty => contador == 0;

  bool get isFull => contador == 15;

  void increment() {
    setState(() {
      contador++;
    });
    print(contador);
  }

// texto pode entrar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        //add da imagens + o fit para colocar na tela toda
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Sorvete.jpeg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isFull ? 'Lotado' : 'Pode Entrar!',
              style:  TextStyle(
                  fontSize: 30,
                  color: isFull ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            // texto 0
            Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                contador.toString(),
                style:  TextStyle(
                    fontSize: 100,
                    color: isFull ?  Colors.red : Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            //botao Saiu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: isEmpty ? null : decrement,
                  style: TextButton.styleFrom(
                      // cor da letra e cor do fundo da letra
                      backgroundColor: isEmpty
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white,
                      //tamanho do branco
                      fixedSize: const Size(100, 100),
                      //tipo de borda
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: const Text(
                    'Saiu',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                //botao entrar
                TextButton(
                  onPressed: isFull ? null : increment,
                  style: TextButton.styleFrom(
                      // cor da letra e cor do fundo da letra
                      backgroundColor:
                          isFull ? Colors.white.withOpacity(0.3) : Colors.white,
                      //tamanho do branco
                      fixedSize: const Size(100, 100),
                      //tipo de borda
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: const Text(
                    'Entrou',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
