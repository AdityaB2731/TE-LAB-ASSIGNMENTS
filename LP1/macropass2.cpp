#include <bits/stdc++.h>
using namespace std;
struct MNTEntry
{
    string name;
    int pp, kp, mdt_ptr, kpdt_ptr, pnt_ptr;
};
vector<MNTEntry> MNT = {
    {"ONE", 2, 1, 1, 1, 1},
    {"TWO", 2, 1, 5, 2, 4}};
vector<string> PNTAB = {"O", "N", "E", "T", "W", "O"};
vector<pair<string, string>> KPDTAB = {{"E", "AREG"}, {"O", "DREG"}};
vector<string> MDT = {
    "MOVER (P,3) (P,1)",
    "ADD (P,3) (P,2)",
    "MOVEM (P,3) (P,1)",
    "MEND",
    "MOVER (P,3) (P,1)",
    "ADD (P,3) (P,2)",
    "MOVEM (P,3) (P,1)",
    "MEND"};
vector<string> split(string s)
{
    vector<string> res;
    string t;
    for (char c : s)
    {
        if (c == ' ' || c == ',' || c == '\t')
        {
            if (!t.empty())
            {
                res.push_back(t);
                t = "";
            }
        }
        else
        {
            t += c;
        }
    }
    if (!t.empty())
        res.push_back(t);
    return res;
}
int find_macro(string name)
{
    for (int i = 0; i < MNT.size(); i++)
        if (MNT[i].name == name)
            return i;
    return -1;
}
int main()
{
    vector<string> program = {
        "START",
        "READ O",
        "READ T",
        "ONE O, 9",
        "TWO T, 7",
        "STOP",
        "O DS 1",
        "T DS 1",
        "END"};
    vector<string> expanded;
    for (string line : program)
    {
        vector<string> words = split(line);
        if (words.empty())
            continue;
        int idx = find_macro(words[0]);
        if (idx == -1)
        {
            expanded.push_back(line); // Normal instruction
            continue;
        }
        MNTEntry macro = MNT[idx];
        vector<string> actuals(words.begin() + 1, words.end());
        vector<string> APTAB(macro.pp + macro.kp);
        for (int i = 0; i < macro.pp; i++)
            APTAB[i] = (i < actuals.size() ? actuals[i] : "");
        for (int i = 0; i < macro.kp; i++)
            APTAB[macro.pp + i] = KPDTAB[macro.kpdt_ptr - 1 + i].second;
        for (int i = macro.pp; i < actuals.size(); i++)
        {
            string a = actuals[i];
            int eq = a.find('=');
            if (eq != -1)
            {
                string key = a.substr(0, eq);
                string val = a.substr(eq + 1);
                for (int j = 0; j < macro.kp; j++)
                {
                    if (KPDTAB[macro.kpdt_ptr - 1 + j].first == key)
                    {
                        APTAB[macro.pp + j] = val;
                        break;
                    }
                }
            }
        }
        for (int i = macro.mdt_ptr - 1; i < MDT.size(); i++)
        {
            string mline = MDT[i];
            if (mline == "MEND")
                break;
            for (int p = 0; p < macro.pp + macro.kp; p++)
            {
                string token = "(P," + to_string(p + 1) + ")";
                int pos;
                while ((pos = mline.find(token)) != string::npos)
                {
                    mline.replace(pos, token.length(), APTAB[p]);
                }
            }
            expanded.push_back(mline);
        }
    }
    cout << "===== Expanded Program =====\n";
    for (string l : expanded)
        cout << l << "\n";
}