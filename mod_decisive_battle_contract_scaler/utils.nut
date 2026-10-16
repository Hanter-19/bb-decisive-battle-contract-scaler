::DecisiveBattleContractScaler.Utils <- {};

::DecisiveBattleContractScaler.Utils.updateContracts <- function () {
    foreach(s in ::World.EntityManager.getSettlements())
    {
        local contracts = s.getContracts();
        foreach(c in contracts)
        {
            if (::MSU.isKindOf(c, "decisive_battle_contract")) {
                ::DecisiveBattleContractScaler.Mod.Debug.printLog(format("Updating decisive battle contract in %s",
                                                                        s.getName()
                ));
                c.updateDifficultyMult();
            }
        }
    }
};

::DecisiveBattleContractScaler.Utils.upgradeEnemyArmy <- function ( _properties, _faction ) {
    local additionalEnemyNobleStrength = ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.EnemyIncreaseSetting).getValue();
    local additionalEnemyMercenaryStrength = ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.MercenaryIncreaseSetting).getValue();
    
    ::DecisiveBattleContractScaler.Mod.Debug.printLog("Adding noble enemies with budget of " + additionalEnemyNobleStrength);
    ::Const.World.Common.addUnitsToCombat(_properties.Entities, ::Const.World.Spawn.Noble, additionalEnemyNobleStrength, _faction);

    ::DecisiveBattleContractScaler.Mod.Debug.printLog("Adding mercenary enemies with budget of " + additionalEnemyMercenaryStrength);
    ::Const.World.Common.addUnitsToCombat(_properties.Entities, ::Const.World.Spawn.Mercenaries, additionalEnemyMercenaryStrength, _faction);
}

::DecisiveBattleContractScaler.Utils.upgradeAlliedArmy <- function ( _properties, _faction ) {
    local additionalAlliedStrength = ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.AllyIncreaseSetting).getValue();
    
    ::DecisiveBattleContractScaler.Mod.Debug.printLog("Adding noble allies with budget of " + additionalAlliedStrength);
    ::Const.World.Common.addUnitsToCombat(_properties.Entities, ::Const.World.Spawn.Noble, additionalAlliedStrength, _faction);
}

::DecisiveBattleContractScaler.Utils.upgradeFinalBattleArmies <- function ( _properties, _enemyFaction, _alliedFaction ) {
    ::DecisiveBattleContractScaler.Utils.upgradeEnemyArmy(_properties, _enemyFaction);
    ::DecisiveBattleContractScaler.Utils.upgradeAlliedArmy(_properties, _alliedFaction);
}

::DecisiveBattleContractScaler.Utils.simulateEnemyArmy <- function () {
    local dummyContract = ::new("scripts/contracts/contracts/decisive_battle_contract");
    local dummyFaction = -1;
    local addedContractDifficultyMult = ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.DiffMultSetting).getValue();
    local contractDifficultyMult = dummyContract.getDifficultyMult() + addedContractDifficultyMult;
    local expectedEnemyStrength = 150; // assumes the player succeeded at all tasks
    local mercenaryStrength = 60; // vanilla fixed value
    local armyList = [];
    ::Const.World.Common.addUnitsToCombat(armyList, ::Const.World.Spawn.Noble, expectedEnemyStrength * contractDifficultyMult * dummyContract.getScaledDifficultyMult(), dummyFaction);
    ::Const.World.Common.addUnitsToCombat(armyList, ::Const.World.Spawn.Mercenaries, mercenaryStrength * contractDifficultyMult * dummyContract.getScaledDifficultyMult(), dummyFaction);
    local p = {
        Entities = armyList
    };
    ::DecisiveBattleContractScaler.Utils.upgradeEnemyArmy(p, dummyFaction);
    return p.Entities;
};

::DecisiveBattleContractScaler.Utils.simulateAlliedArmy <- function () {
    local dummyContract = ::new("scripts/contracts/contracts/decisive_battle_contract");
    local dummyFaction = -2;
    local addedContractDifficultyMult = ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.DiffMultSetting).getValue();
    local contractDifficultyMult = dummyContract.getDifficultyMult() + addedContractDifficultyMult;
    local expectedAlliedStrength = 90; // assumes the player succeeded at all tasks
    local armyList = [];
    ::Const.World.Common.addUnitsToCombat(armyList, ::Const.World.Spawn.Noble, expectedAlliedStrength * contractDifficultyMult * dummyContract.getScaledDifficultyMult(), dummyFaction);
    local p = {
        Entities = armyList
    };
    ::DecisiveBattleContractScaler.Utils.upgradeAlliedArmy(p, dummyFaction);
    return p.Entities;
};

::DecisiveBattleContractScaler.Utils.logArmy <- function (_armyList) {
    local text = "\nTotal units: " + _armyList.len();
    local freq = {};
    foreach (u in _armyList) {
        local arr = split(u.Script, "/");
        local name = arr.top();
        if (name in freq) {
            freq[name].Count += 1;
        } else {
            freq[name] <- {
                Name = name,
                Count = 1,
                Strength = u.Strength
            }
        }
    }
    local results = ::MSU.Table.values(freq);
    results.sort(@(_a, _b) _a.Strength <=> _b.Strength);
    foreach (u in results) {
        text += "\n" + u.Name + ": " + u.Count;
    }
    ::MSU.Log.printData(text);
};