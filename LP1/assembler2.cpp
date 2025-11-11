#include <fstream>
#include <sstream>
#include <iostream>
#include <bits/stdc++.h>
#include <iomanip>
using namespace std;
struct symbol
{
    int address;
    bool defined;
};
struct literal
{
    string literal;
    int address;
};
int main()
{
    ifstream inter("intermediate.txt"), symtab("symtab.txt"), littab("littab.txt");
    if (!inter || !symtab || !littab)
    {
        cerr << "Error: Missing intermediate/symtab/littab files!" << endl;
        return 1;
    }
    map<string, int> symboltable;
    vector<literal> literaltable;
    string sym, lit;
    int addr;
    bool def;
    while (symtab >> sym >> addr >> def)
    {
        symboltable[sym] = addr;
    }
    while (littab >> lit >> addr)
    {
        literaltable.push_back({lit, addr});
    }
    ofstream output("output.txt");
    string line;
    while (getline(inter, line))
    {
        if (line.find("(AD,)") != string::npos || line.find("(DL,01)") != string::npos)
        {
            continue;
        }
        string token;
        vector<string> parts;
        stringstream ss(line);
        while (ss >> token)
        {
            parts.push_back(token);
        }
        string machinecode = " ";
        for (auto &t : parts)
        {
            if (t.find("(IS,") != string::npos)
            {
                machinecode += t.substr(4, 2)+ " ";
            }
            else if (t.find("AREG") != string::npos)
            {
                machinecode += "1 ";
            }
            else if (t.find("BREG") != string::npos)
            {
                machinecode += "2 ";
            }
            else if (t.find("CREG") != string::npos)
            {
                machinecode += "3 ";
            }
            else if (t.find("DREG") != string::npos)
            {
                machinecode += "4 ";
            }
            else if (t.find("(S,") != string::npos)
            {
                string sym = t.substr(3, t.size() - 4);
                machinecode += to_string(symboltable[sym]) + " ";
            }
            else if (t.find("L,") != string::npos)
            {
                int idx = stoi(t.substr(3, t.size() - 4));
                machinecode += to_string(literaltable[idx-1].address) + " ";
            }
            else if (t.find("C,") != string::npos)
            {
                string val = t.substr(3,t.size()-4);
                machinecode +=val+" ";
            }
        }
        output<<machinecode<<endl;
    }
    output.close();
    cout<<"done"<<endl;
    return 0;
}