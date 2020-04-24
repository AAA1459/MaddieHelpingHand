﻿using Celeste.Mod.MaxHelpingHand.Entities;
using Celeste.Mod.MaxHelpingHand.Triggers;

namespace Celeste.Mod.MaxHelpingHand.Module {
    public class MaxHelpingHandModule : EverestModule {
        public override void Load() {
            TempleEyeTrackingMadeline.Load();
            CameraCatchupSpeedTrigger.Load();
            FlagTouchSwitch.Load();
        }

        public override void Unload() {
            TempleEyeTrackingMadeline.Unload();
            CameraCatchupSpeedTrigger.Unload();
            FlagTouchSwitch.Unload();
        }

        public override void PrepareMapDataProcessors(MapDataFixup context) {
            base.PrepareMapDataProcessors(context);

            context.Add<MaxHelpingHandMapDataProcessor>();
        }
    }
}
