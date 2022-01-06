class RecipeStats {
  final int inNumOfPlans;
  final int numLikes;
  final int numDislikes;

  RecipeStats({
    required this.inNumOfPlans,
    required this.numLikes,
    required this.numDislikes,
  });

  RecipeStats copyWith({
    int? inNumOfPlans,
    int? numLikes,
    int? numDislikes,
  }) =>
      RecipeStats(
        inNumOfPlans: inNumOfPlans ?? this.inNumOfPlans,
        numLikes: numLikes ?? this.numLikes,
        numDislikes: numDislikes ?? this.numDislikes,
      );
}
