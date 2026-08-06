enum Gender { male, female }

class GenderState {
  final Gender? selectedGender;

  const GenderState({this.selectedGender});

  GenderState copyWith({Gender? selectedGender}) {
    return GenderState(selectedGender: selectedGender);
  }
}
