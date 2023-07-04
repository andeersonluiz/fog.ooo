class Validator {
  static const int _limitCaracteresName = 1000;
  static const int _limitCaracteresContent = 10000;

  static String? validateName(String? value) {
    value ??= "";
    if (value.length > _limitCaracteresName) {
      return "Nome deve conter menos de $_limitCaracteresName caracteres";
    }
    return null;
  }

  static String? validateEmail(String? email) {
    final RegExp emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    email ??= "";

    if (email.isEmpty) {
      return null;
    }
    if (!emailValid.hasMatch(email)) {
      return "Email inválido, verifique se está correto.";
    }
    return null;
  }

  static String? validateDropDown(String? value) {
    if (value == "Selecione um assunto") {
      return "Selecione um assunto.";
    }

    return null;
  }

  static String? validadeContent(String? content) {
    content ??= "";
    if (content.isEmpty) {
      return "Conteúdo não pode ser vazio";
    }
    if (content.length > _limitCaracteresContent) {
      return "Conteúdo deve conter menos de $_limitCaracteresName caracteres";
    }
    return null;
  }
}
