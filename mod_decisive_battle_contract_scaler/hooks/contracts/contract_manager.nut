::mods_hookExactClass("contracts/contract_manager", function(o) {
    local startScriptedCombat = o.startScriptedCombat;
    o.startScriptedCombat = function ( _properties = null, _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true ) {
        if (::MSU.isKindOf(this.m.Active, "decisive_battle_contract") && _properties.CombatID == "FinalBattle") {
            ::DecisiveBattleContractScaler.Utils.upgradeFinalBattleArmies(_properties, this.m.Active.getActiveState().Flags.get("EnemyNobleHouse"), this.m.Active.getFaction());
        }
        startScriptedCombat(_properties, _isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking);
    }
});