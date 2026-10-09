class Lesson {
  final int id;
  final String title;
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Lesson copyWith({bool? isCompleted}) {
    return Lesson(
      id: id,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}