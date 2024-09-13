import 'dart:developer';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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

  // Lista de ícones disponíveis (sem repetição)
  List<IconData> icons = [];
  List<IconData?> selectedIcons = [null, null, null, null]; // Baias vazias

  // Guarda o ícone que está sendo arrastado
  IconData? draggingIcon;

  @override
  void initState() {
    super.initState();
    icons = List.from(iconNameMap.keys); // Cópia da lista de ícones
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .30,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Colors.red[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: DragTarget<IconData>(
                onAcceptWithDetails: (details) {
                  setState(() {
                    // Adiciona o ícone de volta ao grid somente se não estiver presente
                    if (!icons.contains(details.data)) {
                      icons.add(details.data);
                    }
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          log("Clique no ícone ${icons[index]}");
                        },
                        child: Draggable<IconData>(
                          data: icons[index],
                          feedback: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              icons[index],
                              color: Colors.white,
                            ),
                          ),
                          childWhenDragging: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            // color: Colors
                            //     .grey, // Mostra uma cor diferente ao arrastar
                            decoration: BoxDecoration(
                              color: Colors.yellow[400],
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Icon(
                              icons[index],
                              color: Colors.black54,
                            ),
                          ),
                          onDragStarted: () {
                            setState(() {
                              draggingIcon = icons[index];
                              icons.removeAt(
                                  index); // Remove o ícone da grid enquanto arrasta
                            });
                          },
                          onDragCompleted: () {
                            setState(() {
                              draggingIcon =
                                  null; // Limpa o ícone que está sendo arrastado
                            });
                          },
                          onDraggableCanceled: (_, __) {
                            setState(() {
                              if (draggingIcon != null) {
                                icons.add(
                                    draggingIcon!); // Adiciona de volta ao grid se não foi aceito
                              }
                              draggingIcon =
                                  null; // Limpa o ícone que está sendo arrastado
                            });
                          },
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(icons[index]),
                            ),
                          ),
                        ),
                      );
                    },
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return DragTarget<IconData>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        if (selectedIcons[index] != null) {
                          // Adiciona o ícone atual da baia de volta ao grid
                          if (!icons.contains(selectedIcons[index]!)) {
                            icons.add(selectedIcons[index]!);
                          }
                        }
                        selectedIcons[index] = details.data;
                        _logSelectedIcons(); // Chama a função para logar os ícones
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return selectedIcons[index] != null
                          ? Draggable<IconData>(
                              data: selectedIcons[index],
                              feedback: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                color: Colors.grey[400],
                                child: Icon(
                                  selectedIcons[index],
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
                                setState(() {
                                  if (!icons.contains(selectedIcons[index]!)) {
                                    icons.add(selectedIcons[
                                        index]!); // Adiciona de volta ao quadro
                                  }
                                  selectedIcons[index] = null; // Limpa a baia
                                });
                              },
                              onDraggableCanceled: (_, __) {
                                setState(() {
                                  if (selectedIcons[index] != null) {
                                    // Adiciona o ícone de volta ao grid superior
                                    if (!icons
                                        .contains(selectedIcons[index]!)) {
                                      icons.add(selectedIcons[index]!);
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                color: Colors.grey[300],
                                child: Icon(selectedIcons[index]),
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
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Função que loga a ordem e os ícones das baias
  void _logSelectedIcons() {
    for (int i = 0; i < selectedIcons.length; i++) {
      final icon = selectedIcons[i];
      if (icon != null) {
        final name = iconNameMap[icon]; // Obtém o nome associado ao ícone
        log('Baia ${i + 1}: ${name ?? 'Desconhecido'}');
      } else {
        log('Baia ${i + 1}: Vazia');
      }
    }
  }
}
