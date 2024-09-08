import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insaaju/configs/code_constants.dart';
import 'package:insaaju/domain/entities/code_item.dart';
import 'package:insaaju/repository/code_item_repository.dart';
import 'package:insaaju/repository/openai_repository.dart';
import 'package:insaaju/states/four_pillars_of_destiny/four_pillars_of_destiny_event.dart';
import 'package:insaaju/states/four_pillars_of_destiny/four_pillars_of_destiny_state.dart';
import 'package:insaaju/utills/format_string.dart';

class FourPillarsOfDestinyBloc extends Bloc<FourPillarsOfDestinyEvent, FourPillarsOfDestinyState>{
  final OpenaiRepository _openaiRepository;
  final CodeItemRepository _codeItemRepository;
  FourPillarsOfDestinyBloc(this._openaiRepository, this._codeItemRepository)
    : super(FourPillarsOfDestinyState.initialize())
     {
      on(_onSetInfo);
      on(_onSendMessage);
      on(_initialize);
      on(_onUnSelected);
      on(_onSendCompatibilityMessage);
    }

    Future<void> _initialize(
      InitializeFourPillarsOfDestinyEvent event,
      Emitter<FourPillarsOfDestinyState> emit
    ) async {
      try{
        final fourPillarsOfDestinyData = await _openaiRepository.getAll(event.info);
        emit(state.copyWith(fourPillarsOfDestinyData: fourPillarsOfDestinyData));
      } on Exception catch (error) {
        emit(state.asFailer(error));
      }
    }

    Future<void> _onSetInfo(
      SelectedInfoFourPillarsOfDestinyEvent event,
      Emitter<FourPillarsOfDestinyState> emit
    )async {
      try{
        add(InitializeFourPillarsOfDestinyEvent(info: event.info));
        emit(state.asSetInfo(event.info));
      } on Exception catch(error){
        emit(state.asFailer(error));
      }
    }

    Future<void> _onUnSelected(
        UnSelectedInfoFourPillarsOfDestinyEvent event,
        Emitter<FourPillarsOfDestinyState> emit
    )async {
      try{
        emit(state.asInitialize());
      } on Exception catch( error ){
        emit(state.asFailer(error));
      }
    }

    Future<void> _onSendCompatibilityMessage(
        SendMessageFourPillarsOfDestinyCompatibilityEvent event,
        Emitter<FourPillarsOfDestinyState> emit
    ) async {
      try {
        final CodeItem messageCodeItem = await _codeItemRepository.fetchCodeItem(
            CodeConstants.four_pillars_of_destiny_compatibility_message_template,
            event.fourPillarsOfDestinyCompatibilityType.getValue()
        );
        final message = formatString(
            messageCodeItem.value,
            [
              event.info[0].name,event.info[0].date, event.info[0].time,
              event.info[1].name,event.info[1].date, event.info[1].time
            ]
        );
        print(message);
      } on Exception catch( error ){
        emit(state.asFailer(error));
      }
    }

    Future<void> _onSendMessage(
      SendMessageFourPillarsOfDestinyEvent event,
      Emitter<FourPillarsOfDestinyState> emit
    ) async {
      try{
        emit(state.asLoading(true));
        final String message = event.info.toMessage(
          event.fourPillarsOfDestinyType,
        );
        
        final chatCompilation = await _openaiRepository.sendMessage(
          event.fourPillarsOfDestinyType.getValue(),
          event.modelCode,
          message
        );

        final bool saved = await _openaiRepository.save(
          event.fourPillarsOfDestinyType,
          chatCompilation,
          event.info
        );
        add(InitializeFourPillarsOfDestinyEvent(info: event.info));
        if(!saved){
          throw Exception('fail saved');
        }
        emit(state.asLoading(false));
      } on Exception catch(error){

        emit(state.asFailer(error));
      }
    }
}