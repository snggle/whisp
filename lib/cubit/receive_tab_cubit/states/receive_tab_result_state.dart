import 'package:whisp/cubit/receive_tab_cubit/a_receive_tab_state.dart';

class ReceiveTabResultState extends AReceiveTabState {
  final List<String> decodedMessagePartList;
  final List<int> brokenMessageIndexList;

  const ReceiveTabResultState({
    required this.decodedMessagePartList,
    required this.brokenMessageIndexList,
  });

  @override
  List<Object?> get props => <Object>[
        decodedMessagePartList,
        brokenMessageIndexList,
      ];
}
