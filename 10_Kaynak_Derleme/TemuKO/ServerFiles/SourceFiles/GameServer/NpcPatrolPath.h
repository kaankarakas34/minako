#pragma once
namespace KnightLab
{
inline bool ValidNpcPatrolPath(const char* path, unsigned capacity, unsigned points, unsigned maxPoints)
{
    if (points == 0) return true;
    if (path == 0 || points > maxPoints || capacity == 0 || points > (capacity - 1) / 8) return false;
    // Each point is exactly four decimal X digits followed by four Z digits.
    // Spreadsheet scientific notation and truncated paths cannot be recovered.
    for (unsigned i = 0; i < points * 8; ++i)
        if (path[i] < '0' || path[i] > '9') return false;
    return true;
}
}
