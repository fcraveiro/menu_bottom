import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';

class MenuViewControllerController extends Controller {
  // Lista de ícones disponíveis (sem repetição)
  NotifierList<IconData> icons = NotifierList();
  // Guarda o ícone que está sendo arrastado
  Notifier<IconData?> draggingIcon = Notifier(null);
  // Baias vazias
  NotifierList<IconData?> selectedIcons = NotifierList()
    ..value = [null, null, null, null];

  @override
  onInit() {
    _logSelectedIcons(); // Loga os ícones iniciais
    icons.value = List.from(iconNameMap.keys); // Cópia da lista de ícones
    draggingIcon = Notifier<IconData?>(null); // Inicializando o draggingIcon
  }

  // Mapeia ícones para nomes
  final Map<IconData, String> iconNameMap = {
    Icons.star: 'Star',
    Icons.favorite: 'Favorite',
    Icons.home: 'Home',
    Icons.settings: 'Settings',
    Icons.access_alarm: 'Alarm',
    Icons.account_circle: 'Account',
    Icons.ac_unit: 'AC Unit',
    Icons.airplanemode_active: 'Airplane',
    Icons.alarm: 'Alarm',
    Icons.announcement: 'Announcement',
    Icons.beach_access: 'Beach',
    Icons.cake: 'Cake',
    Icons.call: 'Call',
    Icons.camera: 'Camera',
    Icons.directions_bike: 'Bike',
  };

  // Função que loga a ordem e os ícones das baias
  void _logSelectedIcons() {
    for (int i = 0; i < selectedIcons.length; i++) {
      final icon = selectedIcons.value[i];
      if (icon != null) {
        final name = iconNameMap[icon]; // Obtém o nome associado ao ícone
        log('Baia ${i + 1}: ${name ?? 'Desconhecido'}');
      } else {
        log('Baia ${i + 1}: Vazia');
      }
    }
  }

  @override
  onClose() {}
}

class MenuViewControllerView extends ViewOf<MenuViewControllerController> {
  MenuViewControllerView({super.key, required super.controller, super.size});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Setup Barra de Ícones',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
        ),
        body: Container(
          width: size.width(100),
          height: size.height(100),
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.width(10)),
              // Quadro principal com todos os ícones
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: size.width(92),
                  height: size.height(30),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      top: size.height(3),
                      left: size.width(1),
                      right: size.width(1)),
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(size.width(4)),
                  ),
                  child: controller.icons.show(
                    (value) => DragTarget<IconData>(
                      onAcceptWithDetails: (details) {
                        // Adiciona o ícone de volta ao grid somente se não estiver presente
                        if (!controller.icons.value.contains(details.data)) {
                          controller.icons.value.add(details.data);
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        return
                            // estou na duvida aqui
                            controller.draggingIcon.show(
                          (value) => GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5),
                            itemCount: controller.icons.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // log(controller.icons.value[index].toString());
                                  final iconName = controller.iconNameMap[
                                      controller.icons.value[index]];
                                  log("Nome do ícone: $iconName");
                                },
                                child: Draggable<IconData>(
                                  data: controller.icons.value[index],
                                  feedback:
                                      // Icone que está sendo arrastado
                                      Container(
                                    width: size.width(15),
                                    height: size.width(15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.green[800],
                                      borderRadius:
                                          BorderRadius.circular(size.width(4)),
                                    ),
                                    child: Icon(
                                      controller.icons.value[index],
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Icone que fica no lugar do que está sendo arrastado
                                  childWhenDragging: Center(
                                    child: Container(
                                      width: size.width(13),
                                      height: size.width(13),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          bottom: size.width(4.9)),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            size.width(3)),
                                      ),
                                      child: Icon(
                                        controller.icons.value[index],
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  onDragStarted: () {
                                    controller.draggingIcon.value =
                                        controller.icons.value[index];
                                    controller.icons.value.removeAt(
                                        index); // Remove o ícone da grid enquanto arrasta
                                  },
                                  onDragCompleted: () {
                                    controller.draggingIcon.value =
                                        null; // Limpa o ícone que está sendo arrastado
                                  },
                                  onDraggableCanceled: (_, __) {
                                    if (controller.draggingIcon.value != null) {
                                      controller.icons.value.add(controller
                                          .draggingIcon
                                          .value!); // Adiciona de volta ao grid se não foi aceito
                                    }
                                    controller.draggingIcon.value =
                                        null; // Limpa o ícone que está sendo arrastado
                                  },
                                  // Ícone que fica no grid
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: size.width(13),
                                      height: size.width(13),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            size.width(3)),
                                      ),
                                      child:
                                          Icon(controller.icons.value[index]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Row com as baias (DragTargets)
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200],
                    ),
                    child:

                        // outra duvida aqui
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return controller.selectedIcons.show(
                          (value) => DragTarget<IconData>(
                            onAcceptWithDetails: (details) {
                              if (controller.selectedIcons.value[index] !=
                                  null) {
                                // Adiciona o ícone atual da baia de volta ao grid
                                if (!controller.icons.value.contains(
                                    controller.selectedIcons.value[index]!)) {
                                  controller.icons.add(
                                      controller.selectedIcons.value[index]!);
                                }
                              }
                              controller.selectedIcons.value[index] =
                                  details.data;
                              controller
                                  ._logSelectedIcons(); // Chama a função para logar os ícones
                            },
                            builder: (context, candidateData, rejectedData) {
                              return controller.selectedIcons.value[index] !=
                                      null
                                  ? Draggable<IconData>(
                                      data:
                                          controller.selectedIcons.value[index],
                                      feedback: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        color: Colors.grey[400],
                                        child: Icon(
                                          controller.selectedIcons.value[index],
                                          color: Colors.white,
                                        ),
                                      ),
                                      childWhenDragging: Container(
                                        width: 70,
                                        height: 70,
                                        alignment: Alignment.center,
                                        color: Colors.grey[200],
                                        child: const Text("Baia",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 15)),
                                      ),
                                      onDragCompleted: () {
                                        if (!controller.icons.value.contains(
                                            controller
                                                .selectedIcons.value[index]!)) {
                                          controller.icons.value.add(controller
                                                  .selectedIcons.value[
                                              index]!); // Adiciona de volta ao quadro
                                        }
                                        controller.selectedIcons.value[index] =
                                            null; // Limpa a baia
                                      },
                                      onDraggableCanceled: (_, __) {
                                        if (controller
                                                .selectedIcons.value[index] !=
                                            null) {
                                          // Adiciona o ícone de volta ao grid superior
                                          if (!controller.icons.value.contains(
                                              controller.selectedIcons
                                                  .value[index]!)) {
                                            controller.icons.add(controller
                                                .selectedIcons.value[index]!);
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        alignment: Alignment.center,
                                        color: Colors.grey[300],
                                        child: Icon(controller
                                            .selectedIcons.value[index]),
                                      ),
                                    )
                                  : Container(
                                      width: 70,
                                      height: 70,
                                      alignment: Alignment.center,
                                      color: Colors.grey[300],
                                      child: const Text("Baia",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 15)),
                                    );
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
