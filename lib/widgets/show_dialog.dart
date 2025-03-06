import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/text_widget.dart';

showImageDialog(String name) {
  Get.dialog(
    barrierDismissible: true,
    Container(
      height: 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            'assets/images/$name',
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 50),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration:
                const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

showTaskDialog() {
  Get.dialog(
    barrierDismissible: true,
    Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/Task sample.PNG',
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 190,
                    left: 45,
                    child: Container(
                      width: 90,
                      height: 93,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/characters/$character.PNG'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 110,
                    left: 40,
                    child: Container(
                      width: 260,
                      height: 220,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: currentLevel == 1
                                  ? [
                                      for (int i = 0;
                                          i < levelOneTasks.length;
                                          i++)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              i == 0
                                                  ? currentItems.contains(
                                                              'Pillow') &&
                                                          currentItems
                                                              .contains('Food')
                                                      ? const Icon(
                                                          Icons.check_box,
                                                          size: 20,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .check_box_outline_blank,
                                                          size: 20,
                                                        )
                                                  : i == 1
                                                      ? currentItems.contains(
                                                              'Medicine Prescriptions')
                                                          ? const Icon(
                                                              Icons.check_box,
                                                              size: 20,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              size: 20,
                                                            )
                                                      : i == 2
                                                          ? currentItems.contains(
                                                                  'Vital Signs Equipment')
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  size: 20,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .check_box_outline_blank,
                                                                  size: 20,
                                                                )
                                                          : i == 3
                                                              ? currentItems
                                                                      .contains(
                                                                          'Prescribed Medicine (2)')
                                                                  ? const Icon(
                                                                      Icons
                                                                          .check_box,
                                                                      size: 20,
                                                                    )
                                                                  : const Icon(
                                                                      Icons
                                                                          .check_box_outline_blank,
                                                                      size: 20,
                                                                    )
                                                              : const Icon(
                                                                  Icons
                                                                      .check_box_outline_blank,
                                                                  size: 20,
                                                                ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              TextWidget(
                                                align: TextAlign.start,
                                                text: levelOneTasks[i]['task'],
                                                fontSize: 13,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ]
                                  : [
                                      for (int i = 0;
                                          i < levelTwoTasks.length;
                                          i++)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              i == 0
                                                  ? currentItems.contains(
                                                              'Pillow') &&
                                                          currentItems
                                                              .contains('Food')
                                                      ? const Icon(
                                                          Icons.check_box,
                                                          size: 20,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .check_box_outline_blank,
                                                          size: 20,
                                                        )
                                                  : i == 1
                                                      ? currentItems.contains(
                                                              'Medicine Prescriptions')
                                                          ? const Icon(
                                                              Icons.check_box,
                                                              size: 20,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              size: 20,
                                                            )
                                                      : i == 2
                                                          ? currentItems.contains(
                                                                  'Vital Signs Equipment')
                                                              ? const Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  size: 20,
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .check_box_outline_blank,
                                                                  size: 20,
                                                                )
                                                          : i == 3
                                                              ? currentItems
                                                                      .contains(
                                                                          'Prescribed Medicine (2)')
                                                                  ? const Icon(
                                                                      Icons
                                                                          .check_box,
                                                                      size: 20,
                                                                    )
                                                                  : const Icon(
                                                                      Icons
                                                                          .check_box_outline_blank,
                                                                      size: 20,
                                                                    )
                                                              : i == 4
                                                                  ? currentItems
                                                                          .contains(
                                                                              'X-Ray')
                                                                      ? const Icon(
                                                                          Icons
                                                                              .check_box,
                                                                          size:
                                                                              20,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .check_box_outline_blank,
                                                                          size:
                                                                              20,
                                                                        )
                                                                  : i == 5
                                                                      ? currentItems
                                                                              .contains('Oximeter')
                                                                          ? const Icon(
                                                                              Icons.check_box,
                                                                              size: 20,
                                                                            )
                                                                          : const Icon(
                                                                              Icons.check_box_outline_blank,
                                                                              size: 20,
                                                                            )
                                                                      : const Icon(
                                                                          Icons
                                                                              .check_box_outline_blank,
                                                                          size:
                                                                              20,
                                                                        ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              TextWidget(
                                                align: TextAlign.start,
                                                text: levelTwoTasks[i]['task'],
                                                fontSize: 13,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 50),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
