#include <iostream>
#include <fstream>
#include <sstream>
#include <map>
#include <vector>
#include <iomanip>
using namespace std;

struct Symbol {
    int address;
    bool defined;
};
struct Literal {
    string literal;
    int address;
};

int main() {
    cout << "Running Pass 2..." << endl;
    ifstream inter("intermediate.txt"), symtab("symtab.txt"), littab("littab.txt");
    if (!inter || !symtab || !littab) {
        cerr << "Error: Missing intermediate/symtab/littab files!" << endl;
        return 1;
    }
    map<string, int> symbolTable;
    vector<Literal> literalTable;
    string sym;
    int addr;
    bool def;
    while (symtab >> sym >> addr >> def)
        symbolTable[sym] = addr;
    string lit;
    while (littab >> lit >> addr)
        literalTable.push_back({lit, addr});

    ofstream output("output.txt");
    string line;
    while (getline(inter, line)) {
        if (line.find("(AD,") != string::npos || line.find("(DL,01)") != string::npos)
            continue; // skip assembler directives and DS
        stringstream ss(line);
        string token;
        vector<string> parts;
        while (ss >> token) parts.push_back(token);
        string machineCode = " ";
        for (auto &t : parts) {
            if (t.find("(IS,") != string::npos) {
                machineCode += t.substr(4, 2) + " ";
            } else if (t.find("AREG") != string::npos)
                machineCode += "1 ";
            else if (t.find("BREG") != string::npos)
                machineCode += "2 ";
            else if (t.find("CREG") != string::npos)
                machineCode += "3 ";
            else if (t.find("DREG") != string::npos)
                machineCode += "4 ";
            else if (t.find("(S,") != string::npos) {
                string symName = t.substr(3, t.size() - 4);
                machineCode += to_string(symbolTable[symName]) + " ";
            } else if (t.find("(L,") != string::npos) {
                int idx = stoi(t.substr(3, t.size() - 4));
                machineCode += to_string(literalTable[idx - 1].address) + " ";
            } else if (t.find("(C,") != string::npos) {
                string val = t.substr(3, t.size() - 4);
                machineCode += val + " ";
            }
        }
        output << machineCode << endl;
    }
    output.close();
    cout << "Pass 2 complete ✅\nOutput: output.txt generated successfully.\n";
    return 0;
}
