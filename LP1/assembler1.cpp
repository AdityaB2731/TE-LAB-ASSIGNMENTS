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
bool isRegister(const string &operand)
{
    vector<string> registers = {"AREG", "BREG", "CREG", "DREG"};
    for (auto reg : registers)
    {
        if (reg == operand)
        {
            return true;
        }
    }
    return false;
}
int findliteralindex(vector<literal> &literaltable, string &lit)
{
    for (int i = 0; i < literaltable.size(); i++)
    {
        if (literaltable[i].literal == lit)
        {
            return i + 1;
        }
    }
    return -1;
}
int main()
{
    ifstream input("input.asm");
    if (!input)
    {
        cerr << "error" << endl;
        return 1;
    }
    map<string, pair<string, string>> MOT = {
        {"STOP", {"IS", "00"}},
        {"ADD", {"IS", "01"}},
        {"SUB", {"IS", "02"}},
        {"MULT", {"IS", "03"}},
        {"MOVER", {"IS", "04"}},
        {"MOVEM", {"IS", "05"}},
        {"COMP", {"IS", "06"}},
        {"BC", {"IS", "07"}},
        {"DIV", {"IS", "08"}},
        {"READ", {"IS", "09"}},
        {"PRINT", {"IS", "10"}},
        {"START", {"AD", "01"}},
        {"END", {"AD", "02"}},
        {"ORIGIN", {"AD", "03"}},
        {"EQU", {"AD", "04"}},
        {"LTORG", {"AD", "05"}},
        {"DS", {"DL", "01"}},
        {"DC", {"DL", "02"}},
    };
    map<string, int> condcode = {{"LT", 1}, {"LE", 2}, {"EQ", 3}, {"GT", 4}, {"GE", 5}, {"ANY", 6}};
    map<string, symbol> symboltable;
    vector<literal> literaltable;
    vector<string> intermediatecode;
    vector<int> pooltable = {1};
    int lc = 0;
    string line;
    while (getline(input, line))
    {
        if (line.empty())
        {
            continue;
        }
        istringstream iss(line);
        string label, opcode, operand1, operand2;
        iss >> label;
        if (MOT.find(label) != MOT.end())
        {
            opcode = label;
            label = "";
        }
        else
        {
            iss >> opcode;
        }
        iss >> operand1 >> operand2;
        if (!label.empty() && !isRegister(label))
        {
            symboltable[label].address = lc;
            symboltable[label].defined = true;
        }
        if (opcode == "START")
        {
            lc = stoi(operand1);
            intermediatecode.push_back("\t (AD,01) (C," + operand1 + ")");
        }
        else if (opcode == "END" || opcode == "LTORG")
        {
            intermediatecode.push_back(to_string(lc) + "\t(AD," + MOT[opcode].second + ")");
            for (int i = pooltable.back() - 1; i < literaltable.size(); i++)
            {
                if (literaltable[i].address == -1)
                {
                    literaltable[i].address = lc++;
                }
            }
            if (literaltable.size() >= pooltable.back())
            {
                pooltable.push_back(literaltable.size() + 1);
            }
        }
        else if (opcode == "ORIGIN")
        {
            int new_lc = 0;
            if (operand1.find('+') != string::npos)
            {
                string sym = operand1.substr(0, operand1.find('+'));
                int addr = stoi(operand1.substr(operand1.find('+') + 1));
                new_lc = symboltable[sym].address + addr;
            }
            else if (operand1.find('-') != string::npos)
            {
                string sym = operand1.substr(0, operand1.find('-'));
                int addr = stoi(operand1.substr(operand1.find('-') + 1));
                new_lc = symboltable[sym].address - addr;
            }
            else if (operand1.find('+') != string::npos)
            {
                new_lc = symboltable[operand1].address;
            }
            else
            {
                new_lc = stoi(operand1);
            }
            int old_lc = lc;
            lc = new_lc;
            intermediatecode.push_back(to_string(old_lc) + "\t (AD,03) (C," + to_string(lc) + ")");
        }
        else if (opcode == "EQU")
        {
            int value = 0;
            if (operand1.find('+') != string::npos)
            {
                string sym = operand1.substr(0, operand1.find('+'));
                int addr = stoi(operand1.substr(operand1.find('+') + 1));
                value = symboltable[sym].address + addr;
            }
            else if (operand1.find('-') != string::npos)
            {
                string sym = operand1.substr(0, operand1.find('-'));
                int addr = stoi(operand1.substr(operand1.find('-') + 1));
                value = symboltable[sym].address - addr;
            }
            else if (operand1.find('+') != string::npos)
            {
                value = symboltable[operand1].address;
            }
            else
            {
                value = stoi(operand1);
            }
            symboltable[label] = {value, true};
            intermediatecode.push_back(to_string(lc) + "\t (AD,03) (C," + to_string(value) + ")");
        }
        else if (opcode == "BC")
        {
            string code = "(" + MOT[opcode].first + "," + MOT[opcode].second + ")";
            int cc = condcode[operand1];
            string sym = operand2;
            code += "(C," + to_string(cc) + ")"
                                            "(S," +
                    operand2 + ")";
            intermediatecode.push_back(to_string(lc) + "\t" + code);
            lc++;
        }
        else if (opcode == "DS")
        {
            symboltable[label] = {lc, true};
            intermediatecode.push_back(to_string(lc) + "\t (DL,01) (C," + operand1 + ")");
            lc += stoi(operand1);
        }
        else if (opcode == "DC")
        {
            symboltable[label] = {lc, true};
            intermediatecode.push_back(to_string(lc) + "\t (DL,02) (C," + operand1 + ")");
            lc++;
        }
        else if (MOT.find(opcode) != MOT.end())
        {
            string code = "(" + MOT[opcode].first + "," + MOT[opcode].second + ")";
            if (!operand1.empty())
            {
                code += "(S," + operand1 + ",)";
            }
            if (!operand2.empty())
            {
                if (operand2[0] == '=')
                {
                    int litindex = findliteralindex(literaltable, operand2);
                    if (litindex == -1)
                    {
                        literaltable.push_back({operand2, litindex});
                        litindex = literaltable.size();
                    }
                    code += "(L," + to_string(litindex) + ")";
                }
                else
                {
                    code += "(S," + operand2 + ",)";
                }
            }
            intermediatecode.push_back(to_string(lc) + "\t" + code);
            lc++;
        }
    }
    ofstream inter("intermediate.txt"), sym("symtab.txt"), lit("littab.txt"), pool("pooltab.txt");
    for (auto ic : intermediatecode)
    {
        inter << ic << endl;
    }
    for (auto it : symboltable)
    {
        if (!isRegister(it.first))
        {
            sym << it.first << " " << it.second.address << " " << it.second.defined << endl;
        }
    }
    for (auto it : literaltable)
    {
        lit << it.literal << " " << it.address << endl;
    }
    for (auto it : pooltable)
    {
        pool << it << endl;
    }

    return 0;
}