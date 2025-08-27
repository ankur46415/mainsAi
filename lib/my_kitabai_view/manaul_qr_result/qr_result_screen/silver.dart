import '../../../app_imports.dart';

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.meeting,
        borderRadius: BorderRadius.circular(5),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
