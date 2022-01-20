import 'package:flutter/material.dart';
import 'package:pet_world/classes/pet.dart';
import 'package:pet_world/constants.dart';

class PetTile extends StatelessWidget {
  const PetTile({Key? key, required this.index, required this.petList}) : super(key: key);
  final int index;
  final List<Pet> petList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: Key(index.toString()),
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        petList[index].name ?? '',
                        style: const TextStyle(fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(Strings.AGE + ":" + petList[index].month.toString() + " " + Strings.MONTHS),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
