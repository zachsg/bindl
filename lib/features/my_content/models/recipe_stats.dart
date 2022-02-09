class RecipeStats {
  final int inNumCookbooks;
  final int inNumOfPlans;
  final int numLikes;
  final int numDislikes;

  RecipeStats({
    required this.inNumCookbooks,
    required this.inNumOfPlans,
    required this.numLikes,
    required this.numDislikes,
  });

  RecipeStats copyWith({
    int? inNumCookbooks,
    int? inNumOfPlans,
    int? numLikes,
    int? numDislikes,
  }) =>
      RecipeStats(
        inNumCookbooks: inNumCookbooks ?? this.inNumCookbooks,
        inNumOfPlans: inNumOfPlans ?? this.inNumOfPlans,
        numLikes: numLikes ?? this.numLikes,
        numDislikes: numDislikes ?? this.numDislikes,
      );
}
