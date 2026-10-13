::mods_hookExactClass("contracts/contracts/decisive_battle_contract", function(o) {

    o.m.OriginalDifficultyMult <- null;

    local create = o.create;
    o.create = function () {
        create();
        this.m.OriginalDifficultyMult = this.m.DifficultyMult; // Store the original value so that if the mod setting is changed and we want to update contracts that have already been spawned, we can simply add the new configured value to the original multiplier
        this.updateDifficultyMult();
    }

    o.updateDifficultyMult <- function () {
        local newDifficultyMult = this.m.OriginalDifficultyMult + ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.DiffMultSetting).getValue();
        local logText = format("Updating contract difficulty multiplier from %.1f to %.1f",
                                this.m.OriginalDifficultyMult,
                                newDifficultyMult
        );
        ::DecisiveBattleContractScaler.Mod.Debug.printLog(logText);
        this.m.DifficultyMult = newDifficultyMult;
    }

    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function(_in) {
        onDeserialize(_in);
        this.updateDifficultyMult();
    }

});