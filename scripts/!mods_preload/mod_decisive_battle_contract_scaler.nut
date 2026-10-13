::DecisiveBattleContractScaler <- {
    Version = "1.0.0",
    ID = "mod_decisive_battle_contract_scaler",
    Name = "Decisive Battle Contract Scaler"
};

::mods_registerMod(::DecisiveBattleContractScaler.ID, ::DecisiveBattleContractScaler.Version, ::DecisiveBattleContractScaler.Name);

::mods_queue(::DecisiveBattleContractScaler.ID, "mod_msu(>=1.9.0)", function() {
    ::DecisiveBattleContractScaler.Mod <- ::MSU.Class.Mod(::DecisiveBattleContractScaler.ID, ::DecisiveBattleContractScaler.Version, ::DecisiveBattleContractScaler.Name);

    ::DecisiveBattleContractScaler.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/Hanter-19/bb-decisive-battle-contract-scaler");
    ::DecisiveBattleContractScaler.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

    ::include("mod_decisive_battle_contract_scaler/const.nut");
    ::include("mod_decisive_battle_contract_scaler/utils.nut");
    ::include("mod_decisive_battle_contract_scaler/settings/mod_settings.nut");

    foreach (file in ::IO.enumerateFiles("mod_decisive_battle_contract_scaler/hooks")) {
        ::include(file);
    }

    ::DecisiveBattleContractScaler.Mod.Debug.enable();
});