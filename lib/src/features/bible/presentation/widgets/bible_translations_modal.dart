import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/application/translations/translations_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/presentation/widgets/translation_widget.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class BibleTranslationsModal extends StatelessWidget {
  const BibleTranslationsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TranslationsCubit, TranslationsState>(
      listener: (context, state) {
        state.downloadOption.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.showBibleError(failure),
            (r) => null,
          ),
        );
      },
      child: MModal(
        title: 'Bible Translations',
        builder: (context) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MText('Offline Translations',
                  style: MTextStyle.microRegular),
              MCore.small.verticalSpace,
              const OfflineBibleTranslationsList(),
              MCore.xxLarge.verticalSpace,
              const MText('Online Translations',
                  style: MTextStyle.microRegular),
              MCore.small.verticalSpace,
              const OnlineBibleTranslationsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class OfflineBibleTranslationsList extends StatelessWidget {
  const OfflineBibleTranslationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TranslationsCubit>();
    return BlocBuilder<TranslationsCubit, TranslationsState>(
      bloc: bloc,
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: state.offlineTranslations.length,
        separatorBuilder: (context, i) => MCore.large.verticalSpace,
        itemBuilder: (context, index) {
          final translation = state.offlineTranslations[index];

          return TranslationWidget(
            key: ObjectKey(translation.name),
            translation: translation,
            onTap: () {
              bloc.changeTranslation(translation);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class OnlineBibleTranslationsList extends StatelessWidget {
  const OnlineBibleTranslationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TranslationsCubit>();

    return BlocBuilder<TranslationsCubit, TranslationsState>(
      bloc: bloc,
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: state.onlineTranslations.length,
        separatorBuilder: (context, i) => MCore.large.verticalSpace,
        itemBuilder: (context, index) {
          final translation = state.onlineTranslations[index];

          return TranslationWidget(
            key: ObjectKey(translation),
            translation: translation,
            isOffline: false,
            loading: bloc.state.loading,
            onDownload: () => bloc.downloadTranslation(translation),
            onCancel: () => bloc.cancel(true),
            progress: bloc.state.downloadProgress,
          );
        },
      ),
    );
  }
}
