local page = ::DecisiveBattleContractScaler.Mod.ModSettings.addPage("Settings");

local titleText = "Additive multiplier to Decisive Battle contract difficulty";
local descriptionText = @"Adjust how much more difficult you want the Decisive Battle contract to be.

This value is an additive multiplier to the contract's difficulty multiplier. 

By default, the game randomly rolls the contract difficulty multiplier to be between 0.95 (easier) to 1.35 (harder). The value you choose here will be added to the game's rolled value.
For example, if you choose 0.7 and the game rolled 1.2, the final multiplier will be 1.2 + 0.7 = 1.9.
Setting the value to 0 means you will not add any difficulty to the contract.

Changing this value mid-game will affect all current open contracts and future contracts. It will not affect the currently active contract.

The default value set by this mod is %.1f";
descriptionText = format(descriptionText, ::DecisiveBattleContractScaler.Const.DiffMultSettingDefaultValue);

local rangeSetting = ::MSU.Class.RangeSetting(  ::DecisiveBattleContractScaler.Const.DiffMultSetting,
                                                ::DecisiveBattleContractScaler.Const.DiffMultSettingDefaultValue,
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

Only works if a campaign is running.

Note: If you have changed the modifier, you will need to apply the settings for this button to use the new value.
";
local buttonSetting = ::MSU.Class.ButtonSetting(    "SimulateArmy",
                                                    "For Testing",
                                                    "Simulate Army",
                                                    buttonDescriptionText
);

page.addElement(buttonSetting);

buttonSetting.addCallback(function (_data = null){
    if ("State" in ::World && ::World.State != null) {
        local text = format("\nSimulating enemy army with configured additive multiplier = %.1f",
                            ::DecisiveBattleContractScaler.Mod.ModSettings.getSetting(::DecisiveBattleContractScaler.Const.DiffMultSetting).getValue()
        );
        ::MSU.Log.printData(text);
        local army = ::DecisiveBattleContractScaler.Utils.simulateArmy();
        ::DecisiveBattleContractScaler.Utils.logArmy(army);
    } else {
        ::DecisiveBattleContractScaler.Mod.Debug.printWarning("Unable to simulate army: no campaign running");
    }
});