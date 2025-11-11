#include <bits/stdc++.h>
#include <fstream>
using namespace std;
struct MNTEntry
{
    string name;
    int pp, kp, mdt_ptr, pnt_ptr, kpdt_ptr;
};
vector<MNTEntry> MNT;
vector<pair<string, string>> KPDTAB;
vector<string> PNTAB, MDT;
vector<string> split(string s)
{
    vector<string> res;
    string t = "";
    for (char c : s)
    {
        if ((c == ' ') || c == '\t' || c == ',')
        {
            if (!t.empty())
            {
                res.push_back(t);
                t="";
            }
        }
        else
        {
            t += c;
        }
    }
    if (!t.empty())
    {
        res.push_back(t);
    }
    return res;
}
int main()
{
    int n;
    cout << "enter the number of macro you want:" << endl;
    cin >> n;
    cin.ignore();
    for (int i = 0; i < n; i++)
    {
        string line;
        getline(cin, line);
        getline(cin, line);
        vector<string> head = split(line);
        string macro = head[0];
        int pp = 0, kp = 0;
        int mdt_ptr = MDT.size();
        int pnt_ptr = PNTAB.size();
        int kpdt_ptr = KPDTAB.size();
        for (int j = 1; j < head.size(); j++)
        {
            string p = head[j];
            int eq = p.find('=');
            if (eq == -1)
            {
                pp++;
                PNTAB.push_back(p.substr(1));
            }
            else
            {
                string sym = p.substr(1, eq - 1);
                string def = p.substr(eq + 1);
                PNTAB.push_back(sym);
                KPDTAB.push_back({sym, def});
                kp++;
            }
        }
        while (true)
        {
            getline(cin, line);
            if (line == "MEND")
            {
                MDT.push_back(line);
                break;
            }
            vector<string> words = split(line);
            for (auto &w : words)
            {
                if (w[0] == '&')
                {
                    for (int i = 0; i < PNTAB.size(); i++)
                    {
                        if (PNTAB[i] == w.substr(1))
                        {
                            w = "(P," + to_string(i + 1) + ")";
                        }
                    }
                }
            }
            string joined = "";
            for (int i = 0; i < words.size(); i++)
            {
                joined += words[i];
                if (i != words.size() - 1)
                {
                    joined += " ";
                }
            }
            MDT.push_back(joined);
        }
        MNT.push_back({macro, pp, kp, mdt_ptr + 1, pnt_ptr + 1, kpdt_ptr + 1});
    }
    ofstream mdt("mdt.txt");
    ofstream mnt("mnt.txt");
    ofstream pntab("pntab.txt");
    ofstream kpdtab("kptab.txt");
    cout << "Name  PP  KP  MDT_Ptr  KPDT_Ptr\n";
    mnt << "Name  PP  KP  MDT_Ptr  KPDT_Ptr\n";
    for (auto &m : MNT)
    {
        cout << m.name << "\t" << m.pp << "\t" << m.kp
             << "\t" << m.mdt_ptr << "\t" << m.kpdt_ptr << "\n";
        mnt << m.name << "\t" << m.pp << "\t" << m.kp
            << "\t" << m.mdt_ptr << "\t" << m.kpdt_ptr << "\n";
    }
    for (int i = 0; i < PNTAB.size(); i++)
    {
        cout << i + 1 << " : " << PNTAB[i] << "\n";
        pntab << i + 1 << " : " << PNTAB[i] << "\n";
    }
    for (int i = 0; i < KPDTAB.size(); i++)
    {
        cout << i + 1 << " : " << KPDTAB[i].first << "=" << KPDTAB[i].second << "\n";
        kpdtab << i + 1 << " : " << KPDTAB[i].first << "=" << KPDTAB[i].second << "\n";
    }
    for (int i = 0; i < MDT.size(); i++)
    {
        cout << i + 1 << " : " << MDT[i] << "\n";
        mdt << i + 1 << " : " << MDT[i] << "\n";
    }
}
