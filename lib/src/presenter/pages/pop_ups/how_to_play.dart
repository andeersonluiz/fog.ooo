import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fogooo/src/core/utils/utils.dart';

class HowToPlayPopUp extends StatelessWidget {
  final String timeRemaining;
  const HowToPlayPopUp({super.key, required this.timeRemaining});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(
          32.0,
        )),
      ),
      backgroundColor: Colors.black,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: Colors.white)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                  child: Text(
                    "COMO JOGAR",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Descubra o jogador que passou pelo Botafogo a cada dia. A mudança é feita a cada 24h.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                  child: Text(
                    "Próximo jogador em:",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: Text(
                    timeRemaining,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Cores",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text:
                            "As cores indicam o quão perto você está de acertar a característica.\n\n",
                      ),
                      TextSpan(
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 15,
                          fontFamily: 'Arvo',
                          fontWeight: FontWeight.bold,
                        ),
                        text: "Verde",
                      ),
                      const TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text:
                            ": Você acertou exatamente a característica (Ex: se o palpite da idade do jogador for igual à idade do jogador a ser adivinhado, a idade será exibida em verde).\n\n",
                      ),
                      TextSpan(
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 15,
                          fontFamily: 'Arvo',
                          fontWeight: FontWeight.bold,
                        ),
                        text: "Laranja",
                      ),
                      const TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text:
                            ": Você acertou parcialmente a característica (Ex: se você escolheu um jogador com passagem entre [1995-2000] e exibir a cor laranja, signifca que é certo afirmar que o jogador a ser adivinhado jogou em pelo menos um desses anos).\n\n",
                      ),
                      TextSpan(
                        style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arvo'),
                        text: "Vermelho",
                      ),
                      const TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text:
                            ": Você errou a característica (Ex: o jogador palpitado é um Defensor e o jogador a ser adivinhado é Atacante).\n\n",
                      ),
                      TextSpan(
                        style: TextStyle(
                            color: Colors.blueAccent.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arvo'),
                        text: "Setas",
                      ),
                      const TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text:
                            ": As setas indicam se o palpite está acima ou abaixo do seu palpite. Jogadores falecidos são representados com idade máxima. Se o jogador a ser adivinhado for falecido, outros jogadores não falecidos serão exibidos com uma seta para cima.",
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Caracteristicas",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text:
                            "Os dados dos jogadores foram obtidos através da plataforma ",
                      ),
                      TextSpan(
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text: "oGol",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Utils.launchMyUrl(
                                "https://www.ogol.com.br/team_players.php?pos=0&pais=0&epoca_stats_id=0&id=2233&menu=");
                          },
                      ),
                      const TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text: ". Caso haja alguma inconsistência, ",
                      ),
                      TextSpan(
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text: "entre em contato",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Utils.launchMyUrl("mailto:devowlytech@gmail.com");
                          },
                      ),
                      const TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text:
                            " para resolver a questão.\nCom o objetivo de melhorar a experiência no jogo, apenas jogadores com mais de 10 partidas registradas na plataforma do oGol foram incluídos.",
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "País de nascimento",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Representa o país onde o jogador nasceu. País de nascimento ≠ Nacionalidade (Ex: Elkeson é nascido no Brasil, mas possui nacionalidade chinesa)",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Idade",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Indica a idade do jogador. Se o jogador for falecido, exibe \"Falecido\".",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Posição",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Exibe a posição do jogador. Pode ser Goleiro, Defensor, Meia ou Atacante.",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Anos que jogou no Botafogo",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Indica os anos em que estave no Botafogo.",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Convocado pela seleção brasileira",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Exibe se o jogador foi convocado pela seleção brasileira (apenas no nível profissional)",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Dicas",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "A cada 5 tentativas, são revelados alguns caracteres do nome oculto. A cada 5 tentativas adicionais, mais caracteres são exibidos até restar apenas um.",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Text(
                  "BOA SORTE E FOGOOO",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
