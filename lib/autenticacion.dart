

class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Introduzca su nombre de usuario';
    }

    return null;
  }

  
  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Introduzca su contraseña';
    } else if (password.length < 6) {
      return 'Escriba una contraseña mayor a 6 dígitos';
    }

    return null;
  }

    static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Introdusca su correo electónico';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'El correo electrónico es incorrecto';
    }

    return null;
  }
}