import '../../../models/book_model/book.dart';
import '../../../models/client_model/client.dart';
import '../../../models/publisher_model/publisher.dart';

class Validations {


  String? validateEntityName(String? value) {
    if (value!.length < 3) {
      return 'Mínimo de 3 caracteres';
    } else if (value.length > 50) {
      return 'Máximo de 50 caracteres';
    }
    return null;
  }

  String? validateFieldNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  String? validateAmount(String? value) {
    // Check if the value is a valid integer
    int? intValue = int.tryParse(value!);
    if (intValue == null) {
      return 'Este campo suporta apenas números';
    }

    if (intValue < 0) {
      return 'Por favor, informe um valor acima de 0';
    }
    return null;
  }

  String? validatePublisher(Publisher? value) {
    if (value == null) {
      return 'Selecione uma editora';
    }
    return null;
  }

  String? validateBook(Book? value) {
    if (value == null) {
      return 'Selecione um livro';
    }
    return null;
  }

  String? validateClient(Client? value) {
    if (value == null) {
      return 'Selecione um usuário';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Por favor, informe um formato de Email válido';
    }

    return null;
  }
}
