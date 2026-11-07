#pragma once

// Rates are in basis points. The database remains the source of unverified
// base chances; this helper only applies the documented Trina guarantee.
namespace KnightLab
{
inline int UpgradeChance(int baseRate, bool trina, bool regularStep, int originLevel)
{
    int rate = baseRate;
    if (trina)
    {
        if (regularStep && originLevel >= 1 && originLevel <= 4)
            rate = 10000;
        else
            rate += rate * 20 / 100;
    }
    return rate < 0 ? 0 : (rate > 10000 ? 10000 : rate);
}

inline bool UpgradeRollSucceeds(int rate, int roll)
{
    return roll >= 1 && roll <= 10000 && rate >= roll;
}
}
