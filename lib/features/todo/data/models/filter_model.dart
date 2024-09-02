class FilterModel {
  FilterModel({required this.label, this.onPressed, this.isActive = false,});

  final void Function()? onPressed;
  final bool isActive;
  final String label; 
}