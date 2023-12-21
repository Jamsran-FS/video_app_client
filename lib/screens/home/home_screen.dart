import 'package:video_app/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Page page() => const MaterialPage<void>(child: HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case 1:
        onSearch();
        break;
      case 2:
        setState(() {
          _selectedIndex = 1;
        });
        break;
      case 3:
        setState(() {
          _selectedIndex = 2;
        });
        break;
      case 4:
        _scaffoldKey.currentState?.openDrawer();
        break;
    }
  }

  static const List<Widget> _pages = <Widget>[
    NewsScreen(),
    LibraryScreen(),
    ParticipantsScreen()
  ];

  @override
  void initState() {
    super.initState();
  }

  void onSearch() {
    showSearch(
      context: context,
      delegate: SearchPage<Post>(
        items: Provider.of<CommonProvider>(context, listen: false).podcasts,
        searchLabel: 'Хайх . . .',
        suggestion: ListView.builder(
          shrinkWrap: false,
          padding: EdgeInsets.zero,
          itemCount: Provider.of<CommonProvider>(context, listen: false)
              .podcasts
              .length,
          itemBuilder: (BuildContext context, int index) {
            return VideoListItem(
                data: Provider.of<CommonProvider>(context, listen: false)
                    .podcasts[index]);
          },
        ),
        failure: const Center(
          child: Text('Илэрц олдсонгүй :('),
        ),
        filter: (post) => [
          post.title,
          post.text,
        ],
        builder: (post) => VideoListItem(data: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFCBCCD1),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width,
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(color: Color(0xFF2E9DE6)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFFFFFFF),
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 20),
                      child: Row(
                        children: [
                          user.photo != null
                              ? CircleAvatar(
                            maxRadius: 26,
                            backgroundImage: NetworkImage(user.photo!),
                          )
                              : const CircleAvatar(
                            maxRadius: 26,
                            backgroundImage:
                            AssetImage('assets/images/user.png'),
                          ),
                          const SizedBox(width: 14),
                          user.accountType == AccountType.emailAndPassword
                              ? Text(
                            user.email ?? 'Anonymous',
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                                color: Color(0xFFFBFBFB)),
                          )
                              : Text(
                            user.username ?? 'Anonymous',
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                                color: Color(0xFFFBFBFB)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerButton(
                icon: Icons.exit_to_app,
                iconSize: 24,
                text: 'Гарах',
                onPressed: () {
                  context.read<AuthBloc>().add(AppLogoutRequested());
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(toolbarHeight: 0),
        body: Center(
          child: _pages.elementAt(_selectedIndex), //New
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 0.3, color: Colors.black12))),
          height: 60,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: const Color(0xFFFFFFFF),
                selectedItemColor: const Color(0xFF000000),
                unselectedItemColor: Colors.green,
                elevation: 10.0,
                iconSize: 28,
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.search_rounded),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.ondemand_video),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      height: 28.0,
                      width: 28.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0x33A6A6A6)),
                        image: DecorationImage(
                          image: user.photo == null
                              ? const AssetImage('assets/images/user.png')
                              : NetworkImage(user.photo!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final VoidCallback onPressed;

  const _DrawerButton(
      {required this.icon,
      required this.iconSize,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Icon(icon, color: const Color(0xFF3AADFF), size: 24),
      title: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: 0.5,
          color: Color(0xFF3A3A3A),
        ),
      ),
      onTap: onPressed,
    );
  }
}
