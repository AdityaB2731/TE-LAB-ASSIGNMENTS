#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <map>
#include <iomanip>
using namespace std;
struct Symbol
{
    int address;
    bool defined;
};
struct Literal
{
    string literal;
    int address;
};
bool isRegister(const string &operand)
{
    static vector<string> registers = {"AREG", "BREG", "CREG", "DREG"};
    for (auto &reg : registers)
        if (operand == reg)
            return true;
    return false;
}
int findLiteralIndex(const vector<Literal> &literalTable, const string &lit)
{
    for (int i = 0; i < literalTable.size(); ++i)
        if (literalTable[i].literal == lit)
            return i + 1;
    return -1;
}
int main()
{
    ifstream input("input.asm");
    if (!input)
    {
        cerr << "Error: Could not open input.asm!" << endl;
        return 1;
    }
    map<string, pair<string, string>> MOT = {
        {"STOP", {"IS", "00"}}, {"ADD", {"IS", "01"}}, {"SUB", {"IS", "02"}}, {"MULT", {"IS", "03"}}, {"MOVER", {"IS", "04"}}, {"MOVEM", {"IS", "05"}}, {"COMP", {"IS", "06"}}, {"BC", {"IS", "07"}}, {"DIV", {"IS", "08"}}, {"READ", {"IS", "09"}}, {"PRINT", {"IS", "10"}},
        {"START", {"AD", "01"}}, {"END", {"AD", "02"}}, {"ORIGIN", {"AD", "03"}}, {"EQU", {"AD", "04"}}, {"LTORG", {"AD", "05"}}, 
        {"DS", {"DL", "01"}}, {"DC", {"DL", "02"}}};
    map<string, int> condCode = {{"LT", 1}, {"LE", 2}, {"EQ", 3}, {"GT", 4}, {"GE", 5}, {"ANY", 6}};
    map<string, Symbol> symbolTable;
    vector<Literal> literalTable;
    vector<int> poolTable = {1};
    vector<string> intermediateCode;
    int lc = 0;
    string line;
    while (getline(input, line))
    {
        if (line.empty())
            continue;
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
            symbolTable[label].address = lc;
            symbolTable[label].defined = true;
        }
        if (opcode == "START")
        {
            lc = stoi(operand1);
            intermediateCode.push_back("\t(AD,01) (C," + operand1 + ")"); // <-- MODIFIED
        }
        else if (opcode == "END" || opcode == "LTORG")
        {
            intermediateCode.push_back(to_string(lc) + "\t(AD," + MOT[opcode].second + ")"); // <-- MODIFIED
            for (int i = poolTable.back() - 1; i < literalTable.size(); ++i)
            {
                if (literalTable[i].address == -1)
                    literalTable[i].address = lc++;
            }
            if (literalTable.size() >= poolTable.back())
                poolTable.push_back(literalTable.size() + 1);
        }

        else if (opcode == "ORIGIN")
        {
            int new_lc = 0;
            if (operand1.find('+') != string::npos)
            {
                string sym = operand1.substr(0, operand1.find('+'));
                int offset = stoi(operand1.substr(operand1.find('+') + 1));
                new_lc = symbolTable[sym].address + offset;
            }
            else if (operand1.find('-') != string::npos)
            {
                string sym = operand1.substr(0, operand1.find('-'));
                int offset = stoi(operand1.substr(operand1.find('-') + 1));
                new_lc = symbolTable[sym].address - offset;
            }
            else if (symbolTable.find(operand1) != symbolTable.end())
            {
                new_lc = symbolTable[operand1].address;
            }
            else
            {
                new_lc = stoi(operand1);
            }

            int old_lc = lc; // Capture LC before changing it
            lc = new_lc;
            intermediateCode.push_back(to_string(old_lc) + "\t(AD,03) (C," + to_string(lc) + ")"); // <-- MODIFIED
        }
        else if (opcode == "EQU")
        {
            int value = 0;
            if (operand1.find('+') != string::npos)
            {
                string sym = operand1.substr(0, operand1.find('+'));
                int offset = stoi(operand1.substr(operand1.find('+') + 1));
                value = symbolTable[sym].address + offset;
            }
            else if (operand1.find('-') != string::npos)
            {
                string sym = operand1.substr(0, operand1.find('-'));
                int offset = stoi(operand1.substr(operand1.find('-') + 1));
                value = symbolTable[sym].address - offset;
            }
            else if (symbolTable.find(operand1) != symbolTable.end())
            {
                value = symbolTable[operand1].address;
            }
            else
            {
                value = stoi(operand1);
            }
            symbolTable[label] = {value, true};
            intermediateCode.push_back(to_string(lc) + "\t(AD,04) (C," + to_string(value) + ")"); // <-- MODIFIED
        }
        else if (opcode == "BC")
        {
            string code = "(" + MOT[opcode].first + "," + MOT[opcode].second + ")";
            int cc = condCode[operand1];
            string sym = operand2;
            code += " (C," + to_string(cc) + ") (S," + sym + ")";
            intermediateCode.push_back(to_string(lc) + "\t" + code);
            lc++;
        }
        else if (opcode == "DS")
        {
            symbolTable[label] = {lc, true};
            intermediateCode.push_back(to_string(lc) + "\t(DL,01) (C," + operand1 + ")"); // <-- MODIFIED
            lc += stoi(operand1);
        }
        else if (opcode == "DC")
        {
            symbolTable[label] = {lc, true};
            intermediateCode.push_back(to_string(lc) + "\t(DL,02) (C," + operand1 + ")"); // <-- MODIFIED
            lc++;
        }
        else if (MOT.find(opcode) != MOT.end())
        {
            string code = "(" + MOT[opcode].first + "," + MOT[opcode].second + ")";
            if (!operand1.empty())
                code += " (S," + operand1 + ",,)";
            if (!operand2.empty())
            {
                if (operand2[0] == '=')
                {
                    int litIndex = findLiteralIndex(literalTable, operand2);
                    if (litIndex == -1)
                    {
                        literalTable.push_back({operand2, -1});
                        litIndex = literalTable.size();
                    }
                    code += " (L," + to_string(litIndex) + ")";
                }
                else
                    code += " (S," + operand2 + ")";
            }
            intermediateCode.push_back(to_string(lc) + "\t" + code); // <-- MODIFIED
            lc++;
        }
    }
    ofstream inter("intermediate.txt"), sym("symtab.txt"), lit("littab.txt"), pool("pooltab.txt");
    for (auto &ic : intermediateCode)
        inter << ic << "\n";
    for (auto &symb : symbolTable)
        if (!isRegister(symb.first))
            sym << symb.first << " " << symb.second.address << " " << symb.second.defined << "\n";
    for (auto &litEntry : literalTable)
        lit << litEntry.literal << " " << litEntry.address << "\n";
    for (int p : poolTable)
        pool << p << "\n";
    cout << "✅ Files generated: intermediate.txt, symtab.txt, littab.txt, pooltab.txt\n";
    return 0;
}
