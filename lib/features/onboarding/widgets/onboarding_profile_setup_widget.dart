import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/user_controller.dart';
import '../../profile/my_profile/widgets/avatar_picker_widget.dart';
import '../../profile/my_profile/widgets/bio_text_field_widget.dart';
import '../../profile/my_profile/widgets/experience_dropdown_widget.dart';
import '../../profile/my_profile/widgets/handle_text_field_widget.dart';
import '../../profile/my_profile/widgets/name_text_field_widget.dart';

class OnboardingProfileSetupWidget extends ConsumerWidget {
  const OnboardingProfileSetupWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AvatarPickerWidget(),
              SizedBox(width: 8),
              ExperienceDropdownWidget(),
            ],
          ),
          const NameTextFieldWidget(),
          const HandleTextFieldWidget(),
          const BioTextFieldWidget(),
        ],
      ),
    );
  }
}
