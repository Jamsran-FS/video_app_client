import 'package:video_app/index.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _participantBloc = ParticipantBloc();
  final _podcastBloc = PostBloc();
  final _watchLaterBloc = PostBloc();
  late UserAccount _user;
  late bool _isDataLoaded = false;
  bool _isFirst = true;
  bool _podcastLoading = false;
  bool _watchLaterLoading = false;

  Future<void> _onRefresh() async {
    _participantBloc.add(ParticipantGetAll(userID: _user.id));
    _podcastBloc.add(PodcastGetAll(userID: _user.id));
    _watchLaterBloc.add(WatchLaterGetAll(userID: _user.id));
  }

  @override
  void initState() {
    super.initState();

    if (Provider.of<CommonProvider>(context, listen: false)
        .podcasts
        .isNotEmpty) {
      _isDataLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _user = context.select((AuthBloc bloc) => bloc.state.user);
    if (_isFirst && !_isDataLoaded) {
      _isFirst = false;
      _participantBloc.add(ParticipantGetAll(userID: _user.id));
      _podcastBloc.add(PodcastGetAll(userID: _user.id));
      _watchLaterBloc.add(WatchLaterGetAll(userID: _user.id));
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<ParticipantBloc, ParticipantState>(
          bloc: _participantBloc,
          listener: ((context, state) {
            if (state is ParticipantSuccess) {
              Provider.of<CommonProvider>(context, listen: false)
                  .setParticipants(state.data);
            }
          }),
        ),
        BlocListener<PostBloc, PostState>(
          bloc: _podcastBloc,
          listener: ((context, state) {
            if (state is PostLoading) {
              setState(() {
                _podcastLoading = true;
              });
            }
            if (state is PostSuccess) {
              Provider.of<CommonProvider>(context, listen: false)
                  .setPodcasts(state.data);
              setState(() {
                _podcastLoading = false;
              });
            }
            if (state is PostFailure) {
              setState(() {
                _podcastLoading = false;
              });
            }
          }),
        ),
        BlocListener<PostBloc, PostState>(
          bloc: _watchLaterBloc,
          listener: ((context, state) {
            if (state is PostLoading) {
              setState(() {
                _watchLaterLoading = true;
              });
            }
            if (state is PostSuccess) {
              Provider.of<CommonProvider>(context, listen: false)
                  .setWatchLaterList(state.data);
              setState(() {
                _watchLaterLoading = false;
              });
            }
            if (state is PostFailure) {
              setState(() {
                _watchLaterLoading = false;
              });
            }
          }),
        ),
      ],
      child: Consumer<CommonProvider>(
        builder: ((context, provider, child) {
          return RefreshIndicator(
            strokeWidth: 3,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _podcastLoading
                      ? Container(
                          height: 220,
                          color: Colors.white,
                          child: const CustomProgressIndicator(),
                        )
                      : LatestPost(data: provider.specialPodcast()),
                  // Watch later
                  if (_watchLaterLoading) ...[
                    Container(
                      height: 140,
                      color: Colors.white,
                      child: const CustomProgressIndicator(),
                    ),
                  ] else ...[
                    if (provider.watchLaterList.isNotEmpty) ...[
                      WatchLaterWidget(data: provider.watchLaterList, user: _user)
                    ] else ...[
                      Container(
                        height: 12,
                        color: Colors.transparent,
                      ),
                    ],
                  ],
                  _podcastLoading
                      ? const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CustomProgressIndicator(),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: provider.podcasts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PostBody(
                              data: provider.podcasts[index],
                              bottomGap: index + 1 < provider.podcasts.length,
                              hideBody: false,
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
