#include "../../10_Kaynak_Derleme/TemuKO/ServerFiles/SourceFiles/GameServer/UpgradeChance.h"
#include "../../10_Kaynak_Derleme/TemuKO/ServerFiles/SourceFiles/GameServer/NpcPatrolPath.h"
int main()
{
    const int rates[] = {0,1,13,100,500,2000,4000,7000,9999,10000};
    for (int rate : rates)
    {
        int successes = 0;
        for (int roll = 1; roll <= 10000; ++roll)
            if (KnightLab::UpgradeRollSucceeds(rate, roll)) ++successes;
        if (successes != rate) return 1;
    }
    if (KnightLab::UpgradeRollSucceeds(5000, 0)
        || KnightLab::UpgradeRollSucceeds(10000, 10001)) return 2;
    for (int origin = 1; origin <= 4; ++origin)
        if (KnightLab::UpgradeChance(1000, true, true, origin) != 10000) return 3;
    // Do not extend the guaranteed level rule to enchants/conversions or +6.
    if (KnightLab::UpgradeChance(1000, true, false, 4) != 1200) return 4;
    if (KnightLab::UpgradeChance(6000, true, true, 5) != 7200) return 5;
    if (KnightLab::UpgradeChance(6000, false, true, 4) != 6000) return 6;
    if (KnightLab::UpgradeChance(9999, true, true, 6) != 10000) return 7;
    const char valid[]="0478055004800546";
    if (!KnightLab::ValidNpcPatrolPath(valid, sizeof(valid), 2, 20)) return 8;
    if (KnightLab::ValidNpcPatrolPath("4,78055E+14", 11, 2, 20)) return 9;
    if (KnightLab::ValidNpcPatrolPath(valid, sizeof(valid), 3, 20)) return 10;
    if (KnightLab::ValidNpcPatrolPath(valid, sizeof(valid), 2, 1)) return 11;
    if (KnightLab::ValidNpcPatrolPath(0, 0, 1, 20)) return 12;
    if (!KnightLab::ValidNpcPatrolPath(0, 0, 0, 20)) return 13;
    return 0;
}
