#include <bits/stdc++.h>
#include <fstream>
using namespace std;
struct MNTEntry
{
    string name;
    int pp, kp, mdt_ptr, kpdt_ptr, pnt_ptr;
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
        if (c == ' ' || c == ',' || c == '\t')
        {
            if (!t.empty())
                res.push_back(t), t = "";
        }
        else
            t += c;
    }
    if (!t.empty())
        res.push_back(t);
    return res;
}
int main()
{
    int n;
    cout << "Enter number of macros: ";
    cin >> n;
    cin.ignore();
    for (int i = 0; i < n; i++)
    {
        string line;
        getline(cin, line); // MACRO line (ignore)
        getline(cin, line); // prototype line

        vector<string> head = split(line);
        string macro = head[0];
        int pp = 0, kp = 0;
        int pnt_ptr = PNTAB.size();
        int kpdt_ptr = KPDTAB.size();
        int mdt_ptr = MDT.size();
        for (int j = 1; j < head.size(); j++)
        {
            string p = head[j];
            int eq = p.find('=');
            if (eq == -1)
            { // positional
                PNTAB.push_back(p.substr(1));
                pp++;
            }
            else
            { // keyword
                string pname = p.substr(1, eq - 1), def = p.substr(eq + 1);
                PNTAB.push_back(pname);
                KPDTAB.push_back({pname, def});
                kp++;
            }
        }
        while (true)
        {
            getline(cin, line);
            if (line == "MEND")
            {
                MDT.push_back("MEND");
                break;
            }

            vector<string> words = split(line);
            for (string &w : words)
            {
                if (w[0] == '&')
                {
                    for (int k = 0; k < PNTAB.size(); k++)
                        if (PNTAB[k] == w.substr(1))
                            w = "(P," + to_string(k + 1) + ")";
                }
            }
            string joined="";
            for(int k=0;k<words.size();k++){
                joined+=words[k];
                if(k!=words.size()-1) joined+=" ";
            }
            MDT.push_back(joined);
        }

        MNT.push_back({macro, pp, kp, mdt_ptr + 1, kpdt_ptr + 1, pnt_ptr + 1});
    }
    ofstream mdt("mdt.txt");
    ofstream mnt("mnt.txt");
    ofstream kpdtab("kpdtab.txt");
    ofstream pntab("pntab.txt");
    // ---- Print Tables ----
    cout << "\n===== MNT =====\n";
    mnt << "\n===== MNT =====\n";
    cout << "Name  PP  KP  MDT_Ptr  KPDT_Ptr\n";
    mnt << "Name  PP  KP  MDT_Ptr  KPDT_Ptr\n";
    for (auto &m : MNT)
    {
        cout << m.name << "\t" << m.pp << "\t" << m.kp
             << "\t" << m.mdt_ptr << "\t" << m.kpdt_ptr << "\n";
        mnt << m.name << "\t" << m.pp << "\t" << m.kp
            << "\t" << m.mdt_ptr << "\t" << m.kpdt_ptr << "\n";
    }
    cout << "\n===== PNTAB =====\n";
    for (int i = 0; i < PNTAB.size(); i++){
        cout << i + 1 << " : " << PNTAB[i] << "\n";
        pntab << i + 1 << " : " << PNTAB[i] << "\n";
    }
    cout << "\n===== KPDTAB =====\n";
    for (int i = 0; i < KPDTAB.size(); i++){
        cout << i + 1 << " : " << KPDTAB[i].first << "=" << KPDTAB[i].second << "\n";
        kpdtab << i + 1 << " : " << KPDTAB[i].first << "=" << KPDTAB[i].second << "\n";
    }
    cout << "\n===== MDT =====\n";
    for (int i = 0; i < MDT.size(); i++){
        cout << i + 1 << " : " << MDT[i] << "\n";
        mdt << i + 1 << " : " << MDT[i] << "\n";
    }    
}