import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/common/helpers/is_dark.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/pages/home/widgets/new_songs.dart';
import 'package:spotify/presentation/pages/home/widgets/play_list.dart';
import 'package:spotify/presentation/pages/profile/profile.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hidebackbtn: true,
        action: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));
        },icon: const Icon(Icons.person),),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _homeArtistcard(),
            const SizedBox(
              height: 25,
            ),
            _tabs(),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: tabController,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: NewSongs(),
                  ),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const PlayList(),
          ],
        ),
      ),
    );
  }

  Widget _homeArtistcard() {
    return Center(
      child: SizedBox(
        child: SizedBox(
          height: 170,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(AppVectors.frame),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 60.0),
                  child: Image.asset(
                    AppImages.billieHome,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
        controller: tabController,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        dividerColor: Colors.transparent,
        labelColor: context.isDarkMode ? Colors.white : Colors.black,
        tabs: const [
          Text('New',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          Text('English',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          Text('Bollywood',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          Text('Bengali',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ]);
  }
}
