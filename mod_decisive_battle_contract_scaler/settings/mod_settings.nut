local page = ::DecisiveBattleContractScaler.Mod.ModSettings.addPage("Settings");
local strengthDescription = @"Adjust the strength budget when adding %s units to the %s faction in the final battle.

Unaffected by multipliers.

The default value is %d
";
local enemySetting = ::MSU.Class.RangeSetting(  ::DecisiveBattleContractScaler.Const.EnemyIncreaseSetting,
                                                ::DecisiveBattleContractScaler.Const.EnemyIncreaseSettingDefault,
												0,
												2000,
												10,
												"Additional Enemy Noble Strength",
												format(strengthDescription, "noble", "enemy", ::DecisiveBattleContractScaler.Const.EnemyIncreaseSettingDefault)
);

local mercenarySetting = ::MSU.Class.RangeSetting(	::DecisiveBattleContractScaler.Const.MercenaryIncreaseSetting,
													::DecisiveBattleContractScaler.Const.MercenaryIncreaseSettingDefault,
													0,
													2000,
													10,
													"Additional Enemy Mercenary Strength",
													format(strengthDescription, "mercenary", "enemy", ::DecisiveBattleContractScaler.Const.MercenaryIncreaseSettingDefault)
);

local allySetting = ::MSU.Class.RangeSetting(	::DecisiveBattleContractScaler.Const.AllyIncreaseSetting,
												::DecisiveBattleContractScaler.Const.AllyIncreaseSettingDefault,
												0,
												2000,
												10,
												"Additional Allied Strength",
												format(strengthDescription, "noble", "allied", ::DecisiveBattleContractScaler.Const.AllyIncreaseSettingDefault)
);

page.addElement(enemySetting);
page.addElement(mercenarySetting);
page.addElement(allySetting);

page.addElement(::MSU.Class.SettingsDivider("divider0"));

local titleText = "Additive multiplier to Decisive Battle contract difficulty";
local descriptionText = @"Adjust how much more difficult you want the Decisive Battle contract to be.

This value is an additive multiplier to the contract's difficulty multiplier. 

By default, the game randomly rolls the contract difficulty multiplier to be between 0.95 (easier) to 1.35 (harder). The value you choose here will be added to the game's rolled value.
For example, if you choose 0.7 and the game rolled 1.2, the final multiplier will be 1.2 + 0.7 = 1.9.
Setting the value to 0 means you will not add any difficulty to the contract.

Changing this value mid-game will affect all current open contracts and future contracts. It will not affect the currently active contract.

WARNING: this multiplier affects every aspect in of the contract, including the side battles and the pay.

The default value set by this mod is %.1f";
descriptionText = format(descriptionText, ::DecisiveBattleContractScaler.Const.DiffMultSettingDefault);

local rangeSetting = ::MSU.Class.RangeSetting(  ::DecisiveBattleContractScaler.Const.DiffMultSetting,
                                                ::DecisiveBattleContractScaler.Const.DiffMultSettingDefault,
                                                0,
                                                10,
                                                0.1,
                                                titleText,
                                                descriptionText);
page.addElement(rangeSetting);

page.addElement(::MSU.Class.SettingsDivider("divider1"));

rangeSetting.addAfterChangeCallback( function (_oldValue) {
    ::DecisiveBattleContractScaler.Mod.Debug.printLog(format(   "Update DifficultyMultIncrease from %.1f to %.1f",
                                                                _oldValue,
                                                                this.getValue()
    ));
    if ("State" in ::World && ::World.State != null) {
        ::DecisiveBattleContractScaler.Utils.updateContracts();
    }
});

local buttonDescriptionText = @"For Testing: Simulates the enemy army in the final battle and prints its composition to your game logs.

Assumes you completed all side tasks successfully.

Only works if a campaign is running.

Note: If you have changed any modifiers, you will need to apply the settings for this button to use the new value.
";
local buttonSetting = ::MSU.Class.ButtonSetting(    "SimulateEnemyArmy",
                                                    "For Testing",
                                                    "Simulate Enemy Army",
                                                    buttonDescriptionText
);

page.addElement(buttonSetting);

buttonSetting.addCallback(function (_data = null){
    if ("State" in ::World && ::World.State != null) {
        local text = format("\nSimulating enemy army with configured additive multiplier = %.1f, additional enemy strength = %d, additional mercenary strength = %d",
                            ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.DiffMultSetting).getValue(),
							::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.EnemyIncreaseSetting).getValue(),
							::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.MercenaryIncreaseSetting).getValue()
        );
        ::MSU.Log.printData(text);
        local army = ::DecisiveBattleContractScaler.Utils.simulateEnemyArmy();
        ::DecisiveBattleContractScaler.Utils.logArmy(army);
    } else {
        ::DecisiveBattleContractScaler.Mod.Debug.printWarning("Unable to simulate army: no campaign running");
    }
});

local button2DescriptionText = @"For Testing: Simulates the allied army in the final battle and prints its composition to your game logs.

Assumes you completed all side tasks successfully.

Only works if a campaign is running.

Note: If you have changed any modifiers, you will need to apply the settings for this button to use the new value.
";
local button2Setting = ::MSU.Class.ButtonSetting(    "SimulateAlliedArmy",
                                                    "For Testing",
                                                    "Simulate Allied Army",
                                                    button2DescriptionText
);

page.addElement(button2Setting);

button2Setting.addCallback(function (_data = null){
    if ("State" in ::World && ::World.State != null) {
        local text = format("\nSimulating allied army with configured additive multiplier = %.1f, additional allied strength = %d",
                            ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.DiffMultSetting).getValue(),
							::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.AllyIncreaseSetting).getValue()
        );
        ::MSU.Log.printData(text);
        local army = ::DecisiveBattleContractScaler.Utils.simulateAlliedArmy();
        ::DecisiveBattleContractScaler.Utils.logArmy(army);
    } else {
        ::DecisiveBattleContractScaler.Mod.Debug.printWarning("Unable to simulate army: no campaign running");
    }
});