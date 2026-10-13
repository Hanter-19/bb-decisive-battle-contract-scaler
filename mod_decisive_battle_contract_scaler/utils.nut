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

::DecisiveBattleContractScaler.Utils.simulateArmy <- function () {
    local dummyContract = ::new("scripts/contracts/contracts/decisive_battle_contract");
    local addedContractDifficultyMult = ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.DiffMultSetting).getValue();
    local contractDifficultyMult = dummyContract.getDifficultyMult() + addedContractDifficultyMult;
    local expectedEnemyStrength = 150; // assumes the player succeeded at all tasks
    local armyList = [];
    ::Const.World.Common.addUnitsToCombat(armyList, ::Const.World.Spawn.Noble, expectedEnemyStrength * contractDifficultyMult * dummyContract.getScaledDifficultyMult(), -1);
    return armyList;
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