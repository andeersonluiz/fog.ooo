import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fogooo/src/core/utils/validate.dart';
import 'package:fogooo/src/presenter/dataTransferObject/feedback_DTO.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FeedbackPopUp extends StatelessWidget {
  const FeedbackPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();

    final TextEditingController contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final FeedbackDTO feedbackDTO = Provider.of<FeedbackDTO>(context);

    return WillPopScope(
      onWillPop: () async {
        if (nameController.text.isNotEmpty ||
            emailController.text.isNotEmpty ||
            contentController.text.isNotEmpty) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Confirmar saída"),
                  content: Container(
                      width: 300,
                      color: Colors.white,
                      child: const Text(
                          "Todo o conteúdo escrito no feedback será perdido.")),
                  actionsAlignment: MainAxisAlignment.end,
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            side: const BorderSide(
                                color: Colors.black, width: 2)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Sair",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            side: const BorderSide(
                                color: Colors.black, width: 2)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        )),
                  ],
                );
              });
          return false;
        }

        return true;
      },
      child: AlertDialog(
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                          child: Text(
                            "FEEDBACK",
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
                            "Melhore o fog.ooo com seu feedback.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 36.0),
                        child: TextFormField(
                          controller: nameController,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            label: null,
                            focusColor: Colors.white,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(bottom: 5.0),
                            filled: true,
                            errorStyle: TextStyle(color: Colors.white),
                            hintText: "Digite seu nome (opcional).",
                            prefixIcon: Icon(Icons.badge),
                            focusedErrorBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                          validator: Validator.validateName,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 36.0),
                        child: TextFormField(
                          controller: emailController,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            focusColor: Colors.white,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(bottom: 7.0),
                            errorStyle: TextStyle(color: Colors.white),
                            filled: true,
                            hintText: "Digite seu email (opcional).",
                            prefixIcon: Icon(Icons.mail),
                            focusedErrorBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                          validator: Validator.validateEmail,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 36.0),
                        child: DropdownSearch<String>(
                          popupProps: const PopupProps.menu(
                            showSelectedItems: true,
                            fit: FlexFit.loose,
                          ),
                          items: const [
                            "Reclamação",
                            "Bug",
                            "Sugestão de correção ou atualização",
                            'Criticas/elogios'
                          ],
                          validator: Validator.validateDropDown,
                          dropdownBuilder: (ctx, value) => SizedBox(
                            height: 35,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                value!,
                                style: const TextStyle(),
                                minFontSize: 10,
                                maxFontSize: 20,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            baseStyle: TextStyle(),
                            textAlignVertical: TextAlignVertical.center,
                            dropdownSearchDecoration: InputDecoration(
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              errorStyle: TextStyle(color: Colors.white),
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              filled: true,
                            ),
                          ),
                          clearButtonProps: const ClearButtonProps(),
                          onChanged: (value) {
                            subjectController.text = value!;
                          },
                          selectedItem: "Selecione um assunto",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 36.0),
                        child: TextFormField(
                          controller: contentController,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Colors.black,
                          validator: Validator.validadeContent,
                          maxLines: 11,
                          decoration: const InputDecoration(
                            label: null,
                            focusColor: Colors.white,
                            fillColor: Colors.white,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 16.0),
                            errorStyle: TextStyle(color: Colors.white),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            filled: true,
                            hintText:
                                "Digite o conteúdo (Para solicitações relacionadas a um jogador específico, por favor, forneça o nome completo do jogador)",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 36.0),
                        child: SizedBox(
                          width: double.infinity, // <-- Your width
                          height: 60,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  var res = await feedbackDTO.sendFeedback(
                                      Tuple4(
                                          nameController.text,
                                          emailController.text,
                                          subjectController.text,
                                          contentController.text));

                                  if (res) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Feedback enviado com sucesso!! Obrigado",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    nameController.text = "";
                                    emailController.text = "";
                                    subjectController.text = "";
                                    contentController.text = "";
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Houve um erro ao enviar o feedback, tente novamente mais tarde",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        webBgColor:
                                            "linear-gradient(to right, #b00012, #c93d3d)",
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff818181),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  side: const BorderSide(
                                      color: Colors.white, width: 2)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "ENVIAR FEEDBACK",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
