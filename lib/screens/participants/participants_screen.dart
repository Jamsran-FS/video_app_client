import 'package:video_app/index.dart';

class ParticipantsScreen extends StatefulWidget {
  const ParticipantsScreen({super.key});

  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  final _bloc = ParticipantBloc();
  late UserAccount _user;
  bool _loading = false;

  Future<void> _onRefresh() async {
    _bloc.add(ParticipantGetAll(userID: _user.id));
  }

  @override
  Widget build(BuildContext context) {
    _user = context.select((AuthBloc bloc) => bloc.state.user);
    return MultiBlocListener(
      listeners: [
        BlocListener<ParticipantBloc, ParticipantState>(
          bloc: _bloc,
          listener: ((context, state) {
            if (state is ParticipantLoading) {
              setState(() {
                _loading = true;
              });
            }
            if (state is ParticipantSuccess) {
              Provider.of<CommonProvider>(context, listen: false)
                  .setParticipants(state.data);
              setState(() {
                _loading = false;
              });
            }
            if (state is ParticipantFailure) {
              setState(() {
                _loading = false;
              });
            }
          }),
        ),
      ],
      child: Consumer<CommonProvider>(
        builder: ((context, provider, child) {
          return _loading
              ? const CustomProgressIndicator()
              : RefreshIndicator(
                  strokeWidth: 3,
                  onRefresh: _onRefresh,
                  child: ListView(
                    children: [
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: const Color(0xFFFFFFFF),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Container(
                          height: 169,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Онцлох оролцогчид",
                                  style: TextStyle(
                                    color: Color(0xFF1C1C1E),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 140,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 10, 12),
                                  itemCount: provider.topParticipant.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ParticipantViewSmall(
                                      data: provider.topParticipant[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: provider.participants.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ParticipantViewLarge(
                            data: provider.participants[index],
                            bottomGap: index + 1 < provider.participants.length,
                          );
                        },
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
